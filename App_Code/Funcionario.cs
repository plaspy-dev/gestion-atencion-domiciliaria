using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.Data.SqlClient;

[Serializable]
public class Funcionario
{
    public string Id { get; set; }
    public string Nombres { get; set; }
    public string Documento { get; set; }

    public string DocumentoYNombres
    {
        get
        {
            string resultado = Documento + " - " + Nombres;
            return resultado == " - " ? "" : resultado;
        }
    }

    public Funcionario()
    {
    }

    public static Funcionario GetFuncionario(string id)
    {
        Funcionario funcionario = (Funcionario)HttpRuntime.Cache["rh" + id];
        if (funcionario== null)
        {
            funcionario = new Funcionario();

            Query query = new Query("admPersonalHS");

            query += "perId";
            query += "perNombre";
            query += "perDocumento";

            using (CConectorMS conector = new CConectorMS())
            {
                SqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(id) + ""));
                if (reader != null && reader.Read())
                {
                    funcionario.Id= reader["perId"].ToString();
                    funcionario.Documento = reader["perDocumento"].ToString();
                    funcionario.Nombres = reader["perNombre"].ToString();
                }
            }

            HttpRuntime.Cache.Insert("rh" + id, funcionario);
        }
        return funcionario;
    }

    public static void RemoveFuncionario(string id)
    {
        HttpRuntime.Cache.Remove("rh" + id);
    }
}
