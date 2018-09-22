using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Collections;
using SDG.Componentes;
using System.Globalization;

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

            parent = Add("Índices o escalas");
            Add("Barthel", 7, parent);
            Add("Braden", 40, parent);
            Add("Cruz Roja", 76, parent);
            Add("Norton", 78, parent);
            // Add("Indice de Barthel", 8, parent);

            parent = Add("Hoja de gastos");
            Add("Suministros", 9, parent);

            parent = Add("Hoja de enfermería");
            Add("Dieta", 10, parent);
            Add("Control de líquidos", 11, parent);
            Add("Vía", 12, parent);

            parent = Add("Pacientes");
            Add("Categoría de afiliación", 13, parent);
            Add("Ciudad", 139, parent);
            Add("IPS", 162, parent);
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
            Add("Estado", 163, parent);

            parent = Add("Gestión archivo");
            Add("Tipo archivo", 36, parent);
            Add("Tipo de solicitud", 29, parent);

            parent = Add("Farmacia");
            Add("Estado productos", 34, parent);
            Add("Grupos", 35, parent);
            Add("Centro de costos", 83, parent);
            Add("Zonas", 140, parent);

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
            Add("Seguridad paciente", 69, parent);

            parent = Add("Evolución manejo de heridas");
            Add("Piel perilesional", 63, parent);
            Add("Signos de infección", 64, parent);
            Add("Tipo cambios locales de herida", 65, parent);
            Add("Indicaciones terapeuticas", 66, parent);
            Add("Componente educativo", 67, parent);

            parent = Add("Facturación");
            Add("Causal devolución", 74, parent);
            Add("Causal glosa", 75, parent);

            parent = Add("Recursos humanos");
            Add("Empresas en las que labora actualmente", 80, parent);
            Add("Cursos", 81, parent);
            Add("Origen Tarjeta profesional", 84, parent);

            parent = Add("OrganizationExample16 - atención");
            Add("Tipo paciente", 82, parent);

            parent = Add("Valoración enfermería");
            Add("Patrón de percepción y cuidado de la salud", 85, parent);
            // Add("Antecedentes", 86, parent);
            Add("Patrón nutricional y metabólico", 87, parent);
            Add("Patrón de eliminación", 88, parent);
            Add("Patrón actividad y ejercicio", 89, parent);
            Add("Patrón sueño y descanso", 90, parent);
            Add("Patrón cognitivo perceptual", 91, parent);
            Add("Patrón autopercepción y auto concepto 1", 96, parent);
            Add("Patrón autopercepción y auto concepto 2", 92, parent);
            Add("Patrón función y relación", 93, parent);
            Add("Patrón de afrontamiento y tolerancia al stress", 94, parent);
            Add("Patrón de valores y creencias", 95, parent);

            parent = Add("Valoración trabajo social");
            Add("Tipología familiar", 97, parent);
            Add("Como afronta la familia las dificultades?", 98, parent);
            Add("Tenencia", 99, parent);
            Add("Tipo de vivienda", 100, parent);
            Add("Condiciones de la vivienda", 101, parent);
            Add("Pisos", 102, parent);
            Add("Estructura", 103, parent);
            Add("Espacios", 104, parent);
            Add("Varios", 108, parent);
            Add("Servicios públicos", 105, parent);
            Add("Ingresos mensuales", 106, parent);
            Add("Egresos mensuales", 107, parent);

            parent = Add("Valoración Psicología");

            Add("Motivo consulta ", 109, parent);
            Add("Motivo consulta problema", 110, parent);
            // Add("Antecendentes", 111, parent);
            Add("Perfil histórico de desarrollo y funcionamiento", 112, parent);
            Add("Porte", 113, parent);
            Add("Actitud", 114, parent);
            Add("Conciencia", 115, parent);
            Add("Orientación", 116, parent);
            Add("Memoria", 117, parent);
            Add("Atención", 118, parent);
            Add("Pensamiento", 119, parent);
            Add("Curso", 120, parent);
            Add("Contenido", 121, parent);
            Add("Afecto", 122, parent);
            Add("Afecto (Tono)", 123, parent);
            Add("Sensopercepción", 124, parent);
            Add("Conducta Motora", 125, parent);
            Add("Inteligencia", 126, parent);
            Add("Lenguaje verbal", 127, parent);
            Add("Lenguaje escrito", 128, parent);
            Add("Lenguaje mímico", 129, parent);
            Add("Sueño", 130, parent);
            Add("Conducta Alimentaria", 131, parent);
            Add("Conducta Sexual", 132, parent);
            Add("Introspección", 133, parent);
            Add("Prospección", 134, parent);
            Add("Juicio", 135, parent);
            Add("Impresión diagnóstica", 136, parent);
            Add("Plan de tratamiento", 137, parent);

            parent = Add("Archivo");
            Add("Tipo", 138, parent);

            parent = Add("Seguimiento Materno");
            Add("Motivo de consulta", 141, parent);
            Add("Riesgo psicisocial", 142, parent);
            Add("Antecedentes 1", 143, parent);
            Add("Antecedentes 2", 144, parent);
            Add("Antecedentes 3", 145, parent);
            // Add("Formula obstetrica", 146, parent);
            Add("Antecedentes obstetrica", 147, parent);
            Add("Revisión por sistemas", 148, parent);
            Add("Resultados laboratorios", 150, parent);
            Add("Resultados ecografías", 151, parent);
            Add("Examen físico", 152, parent);
            Add("Abdomen", 153, parent);
            Add("Miembros inferiores", 154, parent);
            Add("Plan de manejo", 155, parent);

            parent = Add("Seguimiento posparto");
            Add("Motivo de consulta", 156, parent);
            Add("Antecedentes 1", 157, parent);
            Add("Antecedentes 2", 158, parent);
            Add("Revisión por sistemas", 159, parent);
            Add("Examen físico, senos", 160, parent);
            Add("Examen físico, abdomen", 161, parent);

            parent = Add("MIPRES");
            Add("Servicios", 164, parent);

            parent = Add("Neonatos");

            Add("Cuidados del recien nacido", 173, parent);
            Add("Lactancia materna", 174, parent);
            Add("Antecedentes para el embarazo", 175, parent);
            Add("Antecedentes", 176, parent);
            Add("Antecedentes transfuncionales", 177, parent);

            Add("Valoración de la madre", 165, parent);
            Add("Sintomas de vasos espasmo", 166, parent);
            Add("Senos", 167, parent);
            Add("Abdomen", 168, parent);
            Add("Miembros inferiores", 169, parent);
            Add("Valoración del recien nacido", 170, parent);
            Add("Antecedentes del recien nacido", 171, parent);
            Add("Controles", 172, parent);

            parent = Add("Apoyo Terapeutico");
            Add("Estado cuenta", 178, parent);

            // disponible 179

            // OrganizationExample16
            parent = Add("OrganizationExample16 - Programación");
            Add("Programa", 10017, parent);
            Add("Actividad", 10018, parent);
            Add("Plan", 10019, parent);
            Add("Lugar", 10020, parent);

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
            Varios.Remove(HId.Value);
            Varios.Remove((Varios.Tipo)Convert.ToInt32(HTipo.Value));

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
