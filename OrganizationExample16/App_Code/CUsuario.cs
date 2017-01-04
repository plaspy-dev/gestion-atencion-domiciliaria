using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Configuration;
using SDG.Componentes;
using MySql.Data.MySqlClient;

/// <summary>
/// Descripción breve de CUsuario
/// </summary>
public class CUsuario : Usuario
{
    public CUsuario() { 
    }

    public CUsuario(string id, string nombre, int grupo, string login) : base(id,nombre,grupo, login)
    {
    }

    override protected Usuario ValidateUser() {
        try
        {
            string usuario = CConector.GetCookie("lp");
            string contrasena = CConector.GetCookie("pp");
            return ValidateUser(usuario, Crypt.DesencriptarDES(contrasena, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4")));
        } catch { }
        return null;
    }

    override protected Usuario ValidateUser(string usuario, string passwd)
    {
        if (passwd.Length > 0 && usuario.Length > 0)
        {
            using(CConector conector= new CConector()) 
            {
                MySqlDataReader reader = conector.Query("SELECT id,nombre,grupo,usuario FROM usuario WHERE usuario='" + usuario + "' AND contrasena=PASSWORD(" + Query.GetValor(passwd) + ") AND estado IS NULL");
                if (reader != null && reader.Read())
                {
                    CUsuario pUsuario = new CUsuario(reader["id"].ToString(), reader["nombre"].ToString(), Convert.ToInt32(reader["grupo"].ToString()), reader["usuario"].ToString());

                    if (pUsuario.GetGrupo() > 0)
                    {
                        reader = conector.Query("SELECT url,permiso FROM permisos WHERE grupo='" + pUsuario.GetGrupo() + "'");
                        if (reader != null)
                        {
                            while (reader.Read())
                            {
                                pUsuario.SetPermiso(reader["url"].ToString(), Convert.ToInt32(reader["permiso"]));
                            }
                        }
                    }
                    pUsuario.AddPermiso("__no__", "Contraseña", "~/contrasena.aspx", 1);
                    CConector.SetCookie("lp", pUsuario.GetLogin());
                    CConector.SetCookie("pp", Crypt.EncriptarDES(passwd, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4")), DateTime.Now.AddHours(10));
                    conector.Query("UPDATE usuario SET ingreso=SYSDATE() WHERE id='" + pUsuario.GetID() + "'");

                    // reconstruimos el directorio una vez al dia.
                    return pUsuario;
                }
            }
        }
        return null;
    }
}
