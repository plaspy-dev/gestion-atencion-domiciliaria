using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

public class PrintEventArgs : EventArgs
{
    public string Contenido="";
    public bool pdf = false;
    public PrintEventArgs()
    {
    }
    public PrintEventArgs(bool pdf)
    {
        this.pdf = pdf;
    }
}
