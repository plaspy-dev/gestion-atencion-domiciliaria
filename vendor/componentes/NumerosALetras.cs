using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Web;
using System.ServiceModel;

namespace SDG.Componentes
{
    public class NumerosALetras
    {
        private static string[] m_saCeroAVeinte = {"cero", "un", "dos", "tres", "cuatro", "cinco", "seis", "siete", "ocho", "nueve", "diez",
"once", "doce", "trece", "catorce", "quince", "dieciseis", "diecisiete", "dieciocho", "diecinueve"};
        private static string[] m_saCientos = { "", "ciento", "docientos", "trecientos", "cuatrocientos", "quinientos", "seiscientos", "setecientos", "ochocientos", "novecientos" };
        private static string[] m_saDeca = { "veinte", "treinta", "cuarenta", "cincuenta", "sesenta", "setenta", "ochenta", "noventa" };
        private static string[] m_saMasDeMil = { "", "mil", "millon", "mil millones", "billon" };

        protected static String convert_nn(int val)
        {

	        if (val < 20)
		        return m_saCeroAVeinte[val];
	        for (int v = 0; v < 10; v++) {
		        String dcap = m_saDeca[v];
		        int dval = 20 + 10 * v;
		        if (dval + 10 > val) {
			        if ((val % 10) != 0)
				        return dcap + " y " + m_saCeroAVeinte[val % 10];
			        return dcap;
		        }        
	        }
	        return "";
        }

        protected static String convert_nnn(int val) {

	        String word = "";
	        int rem = val / 100;
	        int mod = val % 100;
	        if (rem > 0) {
		        word = m_saCientos[rem];
		        if (mod > 0) {
			        word = word + " ";
		        }
	        }
	        if (mod > 0) {
		        word = word + convert_nn(mod);
	        } else if(rem<2) {
		        word.Remove(word.Length-1);
                word.Remove(word.Length - 1);
	        }
	        return word;
        }

        public static String ToLetras(double valor)
        {
            string resultado=ToLetras(valor, false);
            if(resultado.Length>0)
                resultado= resultado.Substring(0, 1).ToUpper() + resultado.Substring(1);
            return resultado;
        }

        public static String ToLetras(double valor, bool comas/*=false*/)
        {
	        // redondeamos sin cifras significativas
	        // ASSERT(valor>=0);
	        valor= Math.Floor((double)valor);
	        if(valor<100) 
		        return convert_nn(Convert.ToInt32(valor));
	        if (valor < 1000) 
		        return convert_nnn(Convert.ToInt32(valor));

	        for (int v = 1; v < 5; v++) {

		        double dval = Math.Pow(1000, v);
		        if (dval > valor) {
			        int didx= v-1;
			        double mod = Math.Pow(1000, didx);
			        double l = Math.Floor(valor/mod);
			        double r = valor - (l * mod);
			        String ret;
			        if(didx>1 && l!=1) {
				        ret = convert_nnn(Convert.ToInt32(l)) + " " + m_saMasDeMil[didx] + "es";
			        } else {
				        if(l==1) {
					        if(didx==1 || didx==3)
						        ret = m_saMasDeMil[didx];
					        else ret= convert_nnn(Convert.ToInt32(l)) + " " + m_saMasDeMil[didx];
				        } else ret = convert_nnn(Convert.ToInt32(l)) + " " + m_saMasDeMil[didx];
			        }
			        if (r > 0) {
				        if(comas)
					        ret = ret + ", " + ToLetras(r);
				        else ret = ret + " " + ToLetras(r);
			        }
			        return ret;
		        }
	        }
	        return "";
        }
    }
}
