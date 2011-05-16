<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="RHGuardaFoto.aspx.vb" Inherits="ML.RHGuardaFoto" %>
<%@Import Namespace="System.IO" %>
<%  
    Dim nom = ML.Datos.RRHH.Personal.getRutaTemp(Session.SessionID, "jpg")
    Dim imgBytes = Request.BinaryRead(Request.TotalBytes)
    Dim oFileStream As FileStream
    oFileStream = New FileStream(Request.MapPath(nom), FileMode.Create)
    oFileStream.Write(imgBytes, 0, imgBytes.Length)
    oFileStream.Close()
    Response.Write(nom)
 %><head id="Head1" runat="server" title="" visible="false"/> 