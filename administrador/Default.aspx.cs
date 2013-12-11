using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SDG.Componentes;

public partial class administrador_Default : System.Web.UI.Page
{
    protected TreeNode Add(string titulo, int tipo, TreeNode parent)
    {
        TreeNode hijo = new TreeNode(titulo);
        hijo.NavigateUrl = Request.Url.AbsolutePath + "?tipo=" + tipo.ToString();
        hijo.Selected = tipo.ToString() == Request.QueryString["tipo"];
        parent.ChildNodes.Add(hijo);
        if (hijo.Selected)
        {
            HTipo.Value = tipo.ToString();
            LTipo.Text = titulo;
            parent.Expand();
        }
        return hijo;
    }

    protected TreeNode Add(string titulo)
    {
        TreeNode parent= new TreeNode(titulo);
        parent.Collapse();
        parent.SelectAction = TreeNodeSelectAction.Expand;
        TTipo.Nodes.Add(parent);
        return parent;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        TNombre.Focus();
        if (!IsPostBack)
        {
            if (Request.QueryString["tipo"] == null)
            {
                Response.Redirect(Request.Url.AbsolutePath + "?tipo=1");
                return;
            }

            CUsuario usuario = (CUsuario) Usuario.GetUsuario();

            BAceptar.Enabled= usuario.CanInsert();
            GResultado.Columns[1].Visible = usuario.CanDelete();
            GResultado.Columns[0].Visible = usuario.CanUpdate();

            TreeNode parent = Add("Hoja de ingreso");

            Add("Según", 1, parent);
            Add("Antecedentes", 2, parent);
            Add("Revisión sistemas", 3, parent);
            Add("Examen físico", 4, parent);
            Add("Varios", 5, parent);
            Add("Tipo diagnóstico", 20, parent);
            Add("Nivel de atención", 37, parent);
            Add("Factores de riesgo", 38, parent);
            Add("Plan educativo", 39, parent);
            // Add("Varios Inferior (Hoja de ingreso)", 6, parent); // eliminado.

            parent = Add("Indice de Barthel");
            Add("Grupos", 7, parent);
            // Add("Indice de Barthel", 8, parent);

            parent = Add("Escala Braden");
            Add("Grupos", 40, parent);

            parent = Add("Hoja de gastos");
            Add("Suministros", 9, parent);

            parent = Add("Hoja de enfermería");
            Add("Dieta", 10, parent);
            Add("Control de líquidos", 11, parent);
            Add("Vía", 12, parent);

            parent = Add("Pacientes");
            Add("Categoría de afiliación", 13, parent);
            // Add("Copagos", 14, parent);

            parent = Add("Encuesta de satisfacción al usuario");
            Add("Grupo preguntas", 15, parent);
            // Add("Preguntas", 16, parent);

            parent = Add("Evento adverso o incidente en la IPS");
            Add("Tipo evento", 17, parent);
            Add("Consecuencia del evento", 18, parent);

            parent = Add("Formulación");
            Add("Tipo formulación", 19, parent);
            Add("Área", 22, parent);

            // 20
            /*parent = Add("Autorizaciones");
            Add("Horas", 21, parent);*/

            parent = Add("Valoración apoyo terapeutico");
            Add("Sistema de bajo flujo", 23, parent);
            Add("Sistema de alto flujo", 24, parent);
            Add("Fuerza muscular", 25, parent);

            parent = Add("Registro PQR");
            Add("Clasificación", 26, parent);
            Add("Consecuencias conducta abusiva.", 30, parent);
            Add("Riesgo presentado", 31, parent);
            Add("Medidas implementadas", 32, parent);

            parent = Add("Bitácoras");
            Add("Novedad administrativa", 27, parent);
            Add("Novedad del servicio prestado", 28, parent);

            parent = Add("Gestión archivo");
            Add("Tipo archivo", 36, parent);
            Add("Tipo de solicitud", 29, parent);

            parent = Add("Farmacia");
            Add("Estado productos", 34, parent);
            Add("Grupos", 35, parent);

            parent = Add("Valoración de heridas");
            Add("Color del estoma", 42, parent);
            Add("Estoma a nivel de la piel", 43, parent);
            Add("Complicaciones", 44, parent);
            Add("Estado de la piel", 45, parent);
            Add("Tipo dispositivo", 46, parent);
            Add("Funcional dispositivo", 47, parent);
            Add("Escala de dolor", 48, parent);
            Add("Localización", 49, parent);
            Add("Localización 2", 70, parent);
            Add("Localización 3", 71, parent);
            Add("Mi", 72, parent);
            Add("Pies", 73, parent);
            Add("Etiología", 50, parent);
            Add("Lugar de origen", 51, parent);
            Add("Tejido profundo sospechoso", 52, parent);
            Add("Clasificación", 53, parent);
            Add("Porcentaje de tejido", 54, parent);
            Add("Seleccione", 55, parent);
            Add("Exudado", 56, parent);
            Add("Tipo exudado", 57, parent);
            Add("Piel Circundante", 58, parent);
            Add("Bordes de la herida", 59, parent);
            Add("Olor", 60, parent);
            Add("Signos y sintomas", 61, parent);
            Add("Componente educativo", 62, parent);
            Add("Definición exudado", 68, parent);
            Add("Varios", 69, parent);

            parent = Add("Evolución manejo de heridas");
            Add("Piel perilesional", 63, parent);
            Add("Signos de infección", 64, parent);
            Add("Tipo cambios locales de herida", 65, parent);
            Add("Indicaciones terapeuticas", 66, parent);
            Add("Componente educativo", 67, parent);

            // disponible 72


            if (HTipo.Value.Length == 0)
                Response.Redirect(Request.Url.AbsolutePath + "?tipo=1");
        }
    }

    protected void BAceptar_Click(object sender, EventArgs e)
    {
        if (!IsValid)
            return;
        Query query = new Query("varios");
        using (CConector conector = new CConector())
        {
            string szQuery;
            string mensaje;

            query["nombre"] = TNombre.Text;
            query["descripcion"] = TDescripcion.Text;

            if (HId.Value.Length == 0)
            {
                query["tipo"] = HTipo.Value;
                szQuery = query.GetInsert();
                mensaje = TNombre.Text + " ingresado";
            }
            else
            {
                szQuery = query.GetUpdate("id='" + HId.Value + "'");
                mensaje = TNombre.Text + " editado";
            }
            int res = conector.QueryMod(szQuery, true);
            if (res == -1)
                return;
            if (HId.Value.Length == 0)
                HId.Value = res.ToString();
            if (conector.InsertModificacion(HId.Value) == -1)
                return;

            Procedimientos.RemoveVarios(HId.Value);

            Session["szMensaje"] = mensaje;
            Response.Redirect(Request.Url.AbsolutePath + "?tipo=" + HTipo.Value);
        }
    }

    protected void BCancelar_Click(object sender, EventArgs e)
    {
        Response.Redirect(Request.Url.AbsolutePath + "?tipo=" + HTipo.Value);
    }

    protected void GResultado_SelectedIndexChanged(object sender, EventArgs e)
    {
        HId.Value= GResultado.SelectedDataKey.Value.ToString();
        TNombre.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[2].Text).Trim();
        TDescripcion.Text = HttpUtility.HtmlDecode(GResultado.SelectedRow.Cells[3].Text).Trim();

        ((MasterPageI)Master).SetModificacion(HId.Value);
    }
}
