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

    public string GetDatabase() {

        return "hs";
    }

    public bool CheckEntidad(string entidad)
    {
        if (!string.IsNullOrEmpty(this["entidades"]))
        {
            string[] entidades = this["entidades"].Split(',');
            for (int i = 0; i < entidades.Length; i++)
            {
                if (entidades[i] == entidad)
                {
                    return true;
                }
            }
            return false;
        }
        return true;
    }

    override protected Usuario ValidateUser() {
        try
        {
            string usuario = CConector.GetCookie("loginOrganizationExample15");
            string contrasena = CConector.GetCookie("contrasena");
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
                MySqlDataReader reader = conector.Query("SELECT id,nombre,grupo,usuario,forceurl,personal,cargos,entidades,cumpleanos FROM usuario WHERE usuario='" + usuario + "' AND contrasena=PASSWORD(" + Query.GetValor(passwd) + ") AND estado IS NULL");
                if (reader != null && reader.Read())
                {
                    CUsuario pUsuario = new CUsuario(reader["id"].ToString(), reader["nombre"].ToString(), Convert.ToInt32(reader["grupo"].ToString()), reader["usuario"].ToString());
                    pUsuario["personal"] = reader["personal"].ToString();
                    pUsuario["cargos"] = reader["cargos"].ToString();
                    pUsuario["entidades"] = reader["entidades"].ToString();
                    pUsuario["cumpleanos"] = reader["cumpleanos"].ToString();
                    pUsuario.SetForceURL(reader["forceurl"].ToString());

                    if (pUsuario["cargos"].Length > 0)
                        pUsuario["procedimientos"] = conector.QueryString("SELECT GROUP_CONCAT(DISTINCT medicamento) FROM medicamento_area WHERE area IN (" + pUsuario["cargos"] + ")");

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
                    CConector.SetCookie("loginOrganizationExample15", pUsuario.GetLogin());
                    CConector.SetCookie("contrasena", Crypt.EncriptarDES(passwd, System.Environment.GetEnvironmentVariable("DOMICILIO_SESSION_KEY_4")), DateTime.Now.AddHours(10));
                    conector.Query("UPDATE usuario SET ingreso=SYSDATE() WHERE id='" + pUsuario.GetID() + "'");

                    // reconstruimos el directorio una vez al dia.
#if DEBUG
#else
                    if (HttpRuntime.Cache["directorio_date"]==null || (DateTime)HttpRuntime.Cache["directorio_date"] != DateTime.Now.Date)
                    {
                        HttpRuntime.Cache["directorio_date"] = DateTime.Now.Date;
                        if (!Funcionario.RebuildDirectorio(conector))
                            HttpRuntime.Cache.Remove("directorio_date");
                    }
#endif
                    return pUsuario;
                }
            }
        }
        return null;
    }
}
