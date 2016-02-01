using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SDG.Componentes;
using System.Data.SqlClient;
using MySql.Data.MySqlClient;
using System.Threading;

[Serializable]
public class Funcionario
{
    public string Id { get; set; }
    public string Nombres { get; set; }
    public string Documento { get; set; }
    public string CarId { get; set; }
    public string Cargo { get { return GetCargo(CarId); } }

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


    static public string GetCargo(string id)
    {

        if (string.IsNullOrEmpty(id))
            return "";

        string nombre = (string)HttpRuntime.Cache["cr" + id];
        if (nombre == null)
        {
            using (CConector conector = new CConector())
            {
                nombre = conector.QueryString("SELECT carDescripcion FROM cargo WHERE carId=" + Query.GetValor(id));
                HttpRuntime.Cache.Insert("cr" + id, nombre);
            }
        }
        return nombre;
    }

    public static Funcionario GetFuncionario(string id)
    {
        Funcionario funcionario = (Funcionario)HttpRuntime.Cache["rh" + id];
        if (funcionario== null)
        {
            funcionario = new Funcionario();

            Query query = new Query("recurso_humano");

            query += "perId";
            query += "perNombre";
            query += "perDocumento";
            query += "carId";

            using (CConector conector = new CConector())
            {
                MySqlDataReader reader = conector.Query(query.GetSelect("perId=" + Query.GetValor(id) + ""));
                if (reader != null && reader.Read())
                {
                    funcionario.Id= reader["perId"].ToString();
                    funcionario.Documento = reader["perDocumento"].ToString();
                    funcionario.Nombres = reader["perNombre"].ToString();
                    funcionario.CarId = reader["carId"].ToString();
                }
            }

            HttpRuntime.Cache.Insert("rh" + id, funcionario);
        }
        return funcionario;
    }

    public static bool RebuildDirectorio(CConector conector, string id)
    {
        if (conector.QueryMod(
                string.IsNullOrEmpty(id)
                ? "DELETE FROM directorio"
                : "DELETE FROM directorio WHERE perId=" + Query.GetValor(id)
                    ) == -1)
            return false;

        id= string.IsNullOrEmpty(id) ? "0=0" : string.Format("programacion.perId={0}", Query.GetValor(id));
        // -- ayer
        if (conector.QueryMod("UPDATE directorio LEFT JOIN programacion ON (directorio.perId=programacion.perId) SET acta=actId WHERE " + id + " AND DATE(programacion.prgFechaProg)=DATE(SYSDATE()-INTERVAL 1 DAY) AND prgActivo=1") == -1)
            return false;
        if (conector.QueryMod("INSERT IGNORE directorio (perId,acta) SELECT perId,actId FROM programacion WHERE " + id + " AND DATE(programacion.prgFechaProg)=DATE(SYSDATE()-INTERVAL 1 DAY) AND prgActivo=1 GROUP BY perId") == -1)
            return false;
        // -- manana
        if (conector.QueryMod("UPDATE directorio LEFT JOIN programacion ON (directorio.perId=programacion.perId) SET actm=actId WHERE " + id + " AND DATE(programacion.prgFechaProg)=DATE(SYSDATE()+INTERVAL 1 DAY) AND prgActivo=1") == -1)
            return false;
        if (conector.QueryMod("INSERT IGNORE directorio (perId,actm) SELECT perId,actId FROM programacion WHERE " + id + " AND DATE(programacion.prgFechaProg)=DATE(SYSDATE()+INTERVAL 1 DAY) AND prgActivo=1 GROUP BY perId") == -1)
            return false;
        // -- hoy
        if (conector.QueryMod("UPDATE directorio LEFT JOIN programacion ON (directorio.perId=programacion.perId) SET pacienteh=pacId WHERE " + id + " AND DATE(programacion.prgFechaProg)=DATE(SYSDATE()) AND prgActivo=1") == -1)
            return false;
        if (conector.QueryMod("INSERT IGNORE directorio (perId,pacienteh) SELECT perId,pacId AS pacId FROM programacion WHERE " + id + " AND DATE(programacion.prgFechaProg)=DATE(SYSDATE()) AND prgActivo=1 GROUP BY perId") == -1)
            return false;
        // -- futuro
        if (conector.QueryMod("UPDATE directorio LEFT JOIN programacion ON (directorio.perId=programacion.perId) SET fechaf=prgFechaProg,pacientef=pacId WHERE " + id + " AND  programacion.prgFechaProg>SYSDATE() AND prgActivo=1") == -1)
            return false;
        if (conector.QueryMod("INSERT IGNORE directorio (perId,fechaf,pacientef) SELECT perId,prgFechaProg,pacId AS pacId FROM programacion WHERE " + id + " AND programacion.prgFechaProg>SYSDATE() AND prgActivo=1 GROUP BY perId") == -1)
            return false;
        return true;
    }

    private void _RebuildDirectorio(object pConector)
    {
        CConector conector = (CConector)pConector;
        try
        {
            RebuildDirectorio(conector, null);
            conector.Commit();   
        } finally {
            conector.Dispose();
        }
    }

    public static bool RebuildDirectorio(CConector conector) {

        ParameterizedThreadStart ts = new ParameterizedThreadStart(new Funcionario()._RebuildDirectorio);
        Thread thd = new Thread(ts);

        thd.IsBackground = true;
        
        conector = new CConector();
        conector.StartTransaction();
        thd.Start(conector);

        return true;
    }

    public static void RemoveFuncionario(string id)
    {
        HttpRuntime.Cache.Remove("rh" + id);
    }
}
