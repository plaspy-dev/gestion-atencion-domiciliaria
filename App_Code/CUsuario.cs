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

        string usuario = CConector.GetCookie("loginOrganizationExample15");
        string contrasena = CConector.GetCookie("contrasena");

        return ValidateUser(usuario, contrasena);
    }

    override protected Usuario ValidateUser(string usuario, string passwd)
    {
        if (passwd.Length > 0 && usuario.Length > 0)
        {
            CConectorMS conectorMS = CConectorMS.GetConector();
            CConector conector = CConector.GetConector();

            int grupo = 0;
            string id = "";
            string login = "";
            string forceurl = "";
            string personal = "";
            string cargos = "";
            string entidades = "";

            string nombre = conectorMS.QueryString("SELECT usIdUsuario FROM seg_Usuarios WHERE usIdUsuario='" + usuario + "' AND usClave='" + passwd + "' AND usActivo=1");
            if (nombre.Length > 0)
            {
                MySqlDataReader reader = conector.Query("SELECT id,nombre,grupo,usuario,forceurl,personal,cargos,entidades FROM usuario WHERE usuario='" + usuario + "' AND (estado IS NULL OR estado!=-1)");
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        usuario = reader["nombre"].ToString();
                        id = reader["id"].ToString();
                        login = reader["usuario"].ToString();
                        grupo = Convert.ToInt32(reader["grupo"].ToString());
                        forceurl = reader["forceurl"].ToString();
                        personal = reader["personal"].ToString();
                        cargos = reader["cargos"].ToString();
                        entidades = reader["entidades"].ToString();
                        break;
                    }
                }
                if (id != "")
                {
                    CUsuario pUsuario = new CUsuario(id, usuario, grupo, login);
                    pUsuario["personal"] = personal;
                    pUsuario["cargos"] = cargos;
                    pUsuario["entidades"] = entidades;

                    if (cargos.Length > 0)
                        pUsuario["procedimientos"] = conector.QueryString("SELECT GROUP_CONCAT(DISTINCT medicamento) FROM medicamento_area WHERE area IN (" + cargos + ")");
                    
                    pUsuario.SetForceURL(forceurl);

                    SqlDataReader readerms = null;
                    if (grupo == 0)
                    {
                        readerms = conectorMS.Query("SELECT seg_Menu.meDescMenu AS nombre,seg_Menu.meRuta AS ruta,1 AS ins,1 AS modif,1 AS elim, parent.meDescMenu AS parent"
                                                + " FROM seg_Menu"
                                                + " LEFT JOIN seg_Menu AS parent ON (parent.meIdMenu=seg_Menu.meIdMenuPadre)"
                                            );
                    }
                    else
                    {
                        readerms = conectorMS.Query("SELECT seg_Menu.meDescMenu AS nombre, seg_Menu.meRuta AS ruta,ins,modif,elim,parent.meDescMenu AS parent " +
                                  "FROM dbo.seg_Menu INNER JOIN dbo.fnSeg_ConMenu('" + login + "',0)menuUs ON seg_Menu.meIdMenu = menuUs.IdMenu " +
                                  "LEFT JOIN seg_Menu AS parent ON (parent.meIdMenu=seg_Menu.meIdMenuPadre) " +
                                  " order by parent,seg_Menu.meIdMenuPadre,seg_Menu.meDescMenu,seg_Menu.meidMenu");
                    }

                    if (readerms != null)
                    {
                        while (readerms.Read())
                        {
                            int permisos = 0;
                            if (readerms["ins"].ToString() == "1")
                                permisos += 4;
                            if (readerms["modif"].ToString() == "1")
                                permisos += 8;
                            if (readerms["elim"].ToString() == "1")
                                permisos += 16;
                            if (permisos > 0)
                                permisos += 1;

                            pUsuario.AddPermiso(readerms["parent"].ToString(), readerms["nombre"].ToString(), CURLs.SwitchApp("~" + readerms["ruta"].ToString(), ConfigurationSettings.AppSettings["app"]), permisos);
                        }
                    }

                    if (grupo > 0)
                    {
                        reader = conector.Query("SELECT url,permiso FROM permisos WHERE grupo='" + grupo + "'");
                        if (reader != null)
                        {
                            while (reader.Read())
                            {
                                pUsuario.SetPermiso(reader["url"].ToString(), Convert.ToInt32(reader["permiso"]));
                            }
                        }
                    }
                    CConector.SetCookie("loginOrganizationExample15", login);
                    CConector.SetCookie("contrasena", passwd, DateTime.Now.AddHours(10));
                    conector.Query("UPDATE usuario SET ingreso=SYSDATE() WHERE id='" + id + "'");
                    return pUsuario;
                }
            }
        }
        return null;
    }
}
