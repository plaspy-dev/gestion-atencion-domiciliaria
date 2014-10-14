using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using FileHelpers;
using System.Globalization;

/// <summary>
/// Descripción breve de SIIGOFile
/// </summary>
[Serializable]
[FixedLengthRecord]
public class SIIGOFile
{
    public class NumberConverter : ConverterBase
    {
        private int mDecimals = 2;

        public NumberConverter(int decimals)
        {
            mDecimals = decimals;
        }

        public NumberConverter() { }

        public override object StringToField(string from)
        {
            return Convert.ToDecimal(Int64.Parse(from) / Math.Pow(10,mDecimals));
        }

        public override string FieldToString(object fieldValue)
        {
            return Convert.ToUInt64(Convert.ToDouble(fieldValue) * Math.Pow(10, mDecimals)).ToString();
        }
    }

    public class SIIGONullDateTime : ConverterBase {

        public SIIGONullDateTime() { }
        public override object StringToField(string from)
        {
            try
            {
                if (from != "00000000")
                {
                    DateTime? fecha = DateTime.ParseExact(from, "yyyyMMdd", CultureInfo.InvariantCulture);
                    return fecha;
                }
            } catch { }
            return null;
        }

        public override string FieldToString(object fieldValue)
        {
            // yyyyMMdd
            DateTime? fecha = (DateTime?)fieldValue;
            if (!fecha.HasValue)
                return "00000000";
            return fecha.Value.ToString("yyyyMMdd");
        }
    }

    [FieldFixedLength(1)]
    public string Tipo = "S";
    [FieldFixedLength(3)]
    public int CodigoTipoDocumento = 3;
    [FieldFixedLength(11)]
    public int Documento;
    [FieldFixedLength(5)]
    protected int _Secuencia = 1;
    [FieldFixedLength(13)]
    public Int64 NIT;
    [FieldFixedLength(3)]
    protected int Sucursal = 0;
    [FieldFixedLength(10)]
    public Int64 CuentaContable = 0;
    [FieldFixedLength(13)] // revisar porque el manual dice que son 13
    public Int64 CodigoProducto;
    [FieldFixedLength(8)]
    [FieldConverter(ConverterKind.Date, "yyyyMMdd")]
    public DateTime Fecha;
    [FieldFixedLength(4)]
    public int CentroDeCosto = 0;
    [FieldFixedLength(3)]
    protected int SubCentroDeCosto = 0;
    [FieldFixedLength(50)]
    public string DescripcionDelMovimiento;
    [FieldFixedLength(1)]
    public string DebitoCredito = "C";
    [FieldFixedLength(15)]
    [FieldConverter(typeof(NumberConverter))]
    public decimal ValorMovimiento;
    [FieldFixedLength(15)]
    [FieldConverter(typeof(NumberConverter))]
    protected decimal ValorBase = 0;
    [FieldFixedLength(4)]
    protected int CodigoVendedor = 1;
    [FieldFixedLength(4)]
    protected int CodigoCiudad = 1;
    [FieldFixedLength(3)]
    protected int CodigoZona = 0;
    [FieldFixedLength(4)]
    protected int CodigoBodega = 1;
    [FieldFixedLength(3)]
    protected int CodigoUbicacion = 0;
    [FieldFixedLength(15)]
    [FieldConverter(typeof(NumberConverter), 5)]
    protected decimal nCantidad;


    // de aqui para adelante no se usan.
    [FieldFixedLength(1)]
    public string TipoDocumentoCruze;
    [FieldFixedLength(3)]
    protected string CodigoComprobanteCruze;
    [FieldFixedLength(11)]
    protected Int64 NumeroDocumentoCruze;
    [FieldFixedLength(3)]
    protected int SecuenciaDocumentoCruze;
    [FieldFixedLength(8)]
    [FieldConverter(typeof(SIIGONullDateTime))] // esta en ceros
    protected DateTime? FechaDocumentoCruze;
    [FieldFixedLength(4)]
    protected int CodigoFormaPago;
    [FieldFixedLength(2)]
    protected int CodigoDelBanco;
    [FieldFixedLength(1)]
    public string TipoDocumentoPedido;
    [FieldFixedLength(3)]
    protected int CodigoComprobantePedido;

    // pagina 2
    [FieldFixedLength(11)]
    protected int NumeroDocumentoPedido;
    [FieldFixedLength(3)]
    protected int SecuenciaPedido;
    [FieldFixedLength(97)]
    protected int Relleno1;
    [FieldFixedLength(1)]
    protected string sRelleno1;
    [FieldFixedLength(12)]
    protected int Relleno2;
    [FieldFixedLength(6)]
    protected string sRelleno2;
    [FieldFixedLength(1)]
    protected string Relleno3="0";
    [FieldFixedLength(1)]
    protected string sRelleno3;
    [FieldFixedLength(2)]
    protected int Relleno4;
    [FieldFixedLength(4)]
    protected string sRelleno4;
    [FieldFixedLength(11)]
    protected int Relleno5;
    [FieldFixedLength(10)]
    protected string sRelleno5;

    [FieldFixedLength(10)]
    protected int Relleno6;

    [FieldFixedLength(20)]
    [FieldConverter(typeof(NumberConverter), 5)]
    protected Decimal ValorUnitario;
    [FieldFixedLength(14)]
    protected int Relleno6b;
    [FieldFixedLength(1)]
    protected string sRelleno6;
    [FieldFixedLength(3)]
    protected int Relleno7;
    [FieldFixedLength(13)]
    protected string sRelleno7;
    [FieldFixedLength(48)]
    protected int Relleno8;
    [FieldFixedLength(1)]
    protected string sRelleno8;
    [FieldFixedLength(18)]
    [FieldConverter(typeof(NumberConverter), 5)]
    protected decimal nCantidad2;
    [FieldFixedLength(21)]
    protected int Relleno9;
    [FieldFixedLength(6)]
    protected string sRelleno9;
    [FieldFixedLength(4)]
    protected int Relleno10;
    [FieldFixedLength(83)]
    protected string sRelleno10;

    [FieldFixedLength(36)]
    protected int Relleno11;
    [FieldFixedLength(3)]
    protected string sRelleno11;
    [FieldFixedLength(15)]
    protected int Relleno12;
    [FieldFixedLength(24)]
    protected string sRelleno12;
    [FieldFixedLength(30)]
    protected int Relleno13;
    [FieldFixedLength(67)]
    protected string sRelleno13;
    [FieldFixedLength(15)]
    protected int Relleno14;


    public decimal Cantidad
    {
        set { nCantidad = nCantidad2 = value; }
        get { return nCantidad; }
    }

    public int Secuencia
    {
        get { return _Secuencia; }
        set
        {
            SecuenciaPedido = _Secuencia = value;
        }
    }

    // enumeraciones solo para la facturacion
    public int _Documento { get { return Documento; } }
    public Int64 _NIT { get { return NIT; } }
    public Int64 _CodigoProducto { get { return CodigoProducto; } }
    public DateTime _Fecha { get { return Fecha; } }
    public string _DescripcionDelMovimiento { get { return DescripcionDelMovimiento; } }
    public decimal _ValorMovimiento { get { return ValorMovimiento; } }

    public SIIGOFile()
    {
    }

    public SIIGOFile(bool entrada)
    {
        if (entrada)
        {
            Tipo = "E";
            DebitoCredito = "D";
            CodigoTipoDocumento = 1;
        }
    }

    // esta funcion es para crear la salida
    public SIIGOFile(SIIGOFile salida)
    {

        Tipo = "E";
        DebitoCredito = "D";
        CodigoTipoDocumento = 1;

        /*TipoDocumentoPedido = "C";
        CodigoComprobantePedido = 2;*/

        Documento = salida.Documento;
        NIT = salida.NIT;
        Fecha = salida.Fecha;
        CodigoProducto = salida.CodigoProducto;
        DescripcionDelMovimiento = salida.DescripcionDelMovimiento;
        ValorMovimiento = salida.ValorMovimiento;
        Secuencia = salida.Secuencia;
        Cantidad = salida.Cantidad;
        ValorBase = ValorMovimiento;
        ValorUnitario = ValorBase / Cantidad;
        CuentaContable = 0; // la cuenta de la entrada

        NumeroDocumentoPedido = salida.Documento;
    }

    public SIIGOFile(int documento, Int64 nit, DateTime fecha, Int64 codigoProducto, string descripcionProducto, decimal valor, decimal cantidad)
    {
        Documento = documento;
        NIT = nit;
        Fecha = fecha;
        CodigoProducto = codigoProducto;
        DescripcionDelMovimiento = descripcionProducto;
        ValorMovimiento = valor;
        Cantidad = Math.Abs(cantidad);
    }

    public SIIGOFile(List<SIIGOFile> listae)
    {

        SIIGOFile entrada = listae[0];

        Tipo = "E";
        CodigoTipoDocumento = 1;

        Documento = entrada.Documento;
        NIT = entrada.NIT;
        Fecha = entrada.Fecha;
        CodigoProducto = 0;
        DescripcionDelMovimiento = "OC " + entrada.Documento + " " + NIT;
        ValorMovimiento = listae.Sum(x => x.ValorMovimiento);
        Cantidad = 0;
        // Cantidad = listae.Sum(x=>x.Cantidad);
        Secuencia = listae.Count + 1;
        SecuenciaPedido = 0;

        // de aqui para adelante no se usan.
        TipoDocumentoCruze = "E";
        CodigoComprobanteCruze = "001";
        NumeroDocumentoCruze = Documento;
        SecuenciaDocumentoCruze = 1;
        FechaDocumentoCruze = Fecha;
    }
}