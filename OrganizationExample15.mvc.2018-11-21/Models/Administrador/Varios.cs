using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using SDG.Componentes;

namespace OrganizationExample15.Models.Administrador
{
    public class MVarios : ProtectedField
    {
        public enum Tipo {
            Ninguno=0,
            [Description("Hoja de ingreso/Según")]
            HojaDeIngresoSegun=1,
            [Description("Hoja de ingreso/Antecedentes")]
            HojaDeIngresoAntecendentes=2,
            [Description("Hoja de ingreso/Revisión sistemas")]
            HojaDeIngresoRevisionSistemas=3,
            [Description("Hoja de ingreso/Examen físico")]
            HojaDeIngresoExamenFisico =4,
            [Description("Hoja de ingreso/Varios")]
            HojaDeIngresoVarios =5,
            [Description("Índices o escalas/Barthel")]
            IndiceEscalaBarthel=7,
            [Description("Hoja de gastos/Suministros")]
            HojaDeGastosSuministros=9,
            [Description("Hoja de enfermería/Dieta")]
            HojaDeEnfermeriaDieta =10,
            [Description("Hoja de enfermería/Control de líquidos")]
            HojaDeEnfermeriaControlDeLiquidos =11,
            [Description("Hoja de enfermería/Vía")]
            HojaDeEnfermeriaVia =12,
            [Description("Paciente/Categoría Afiliación")]
            CategoriaEPS=13,
            [Description("")]
            CopagoCategoriaEPS = 14,
            [Description("Encuesta de satisfacción al usuario/Grupo preguntas")]
            EncuestaGrupoPreguntas = 15,
            [Description("")]
            EncuestaUsuarioPreguntas=16,
            [Description("Evento adverso o incidente en la IPS/Tipo evento")]
            EventoAdversoTipo = 17,
            [Description("Evento adverso o incidente en la IPS/Consecuencia del evento")]
            EventoAdversoConsecuencia = 18,
            [Description("Formulación/Tipo formulación")]
            FormulacionTipo = 19,
            [Description("Hoja de ingreso/Tipo diagnóstico")]
            HojaDeIngresoTipoDiagnostico = 20,
            [Description("Formulación/Área")]
            FormulacionArea = 22,
            [Description("Valoración apoyo terapeutico/Sistema de bajo flujo")]
            ValoracionApoyoTerapeuticoBajoFlujo = 23,
            [Description("Valoración apoyo terapeutico/Sistema de alto flujo")]
            ValoracionApoyoTerapeuticoAltoFlujo = 24,
            [Description("Valoración apoyo terapeutico/Fuerza muscular")]
            ValoracionApoyoTerapeuticoFuerzaMuscular = 25,
            [Description("Registro PQR/Clasificación")]
            PQRClasificacion = 26,
            [Description("Bitácoras/Novedad administrativa")]
            BitacorasNovedadAdministrativa = 27,
            [Description("Bitácoras/Novedad del servicio prestado")]
            BitacorasNovedadServicio = 28,
            [Description("Gestión archivo/Tipo de solicitud")]
            GestionArchivoTipoSolicitud = 29,
            [Description("Registro PQR/Consecuencias conducta abusiva")]
            PQRConsecuencias = 30,
            [Description("Registro PQR/Riesgo presentado")]
            PQRRiesgo = 31,
            [Description("Registro PQR/Medidas implementadas")]
            PQRMedidas = 32,
            [Description("")]
            CategoriaCenso = 33,
            [Description("Farmacia/Estado productos")]
            FarmaciaEstado = 34,
            [Description("Farmacia/Grupos")]
            FarmaciaGrupo = 35,
            [Description("Gestión archivo/Tipo archivo")]
            GestionArchivoTipoArchivo = 36,
            [Description("Hoja de ingreso/Nivel de atención")]
            HojaDeIngresoNivelAntencion = 37,
            [Description("Hoja de ingreso/Factores de riesgo")]
            HojaDeIngresoFactoresRiesgo = 38,
            [Description("Hoja de ingreso/Plan educativo")]
            HojaDeIngresoPlanEducativo = 39,
            [Description("Índices o escalas/Braden")]
            IndiceEscalaBraden = 40,
            [Description("Valoración de heridas/Color del estoma")]
            ValoracionHeridasColorEstoma = 42,
            [Description("Valoración de heridas/Estoma a nivel de la piel")]
            ValoracionHeridasEstomaNivelPiel = 43,
            [Description("Valoración de heridas/Complicaciones")]
            ValoracionHeridasComplicaciones = 44,
            [Description("Valoración de heridas/Estado de la piel")]
            ValoracionHeridasEstadoPiel = 45,
            [Description("Valoración de heridas/Tipo dispositivo")]
            ValoracionHeridasTipoDispositivo = 46,
            [Description("Valoración de heridas/Funcional dispositivo")]
            ValoracionHeridasDispositivoFuncional = 47,
            [Description("Valoración de heridas/Escala de dolor")]
            ValoracionHeridasEscalaDolor = 48,
            [Description("Valoración de heridas/Localización")]
            ValoracionHeridasLocalizacion = 49,
            [Description("Valoración de heridas/Etiología")]
            ValoracionHeridasEtiologia = 50,
            [Description("Valoración de heridas/Lugar de origen")]
            ValoracionHeridasLugarOrigen = 51,
            [Description("Valoración de heridas/Tejido profundo sospechoso")]
            ValoracionHeridasTejidoProfundoSospechoso = 52,
            [Description("Valoración de heridas/Clasificación")]
            ValoracionHeridasClasificacion = 53,
            [Description("Valoración de heridas/Porcentaje de tejido")]
            ValoracionHeridasPorcentajeTejido = 54,
            [Description("Valoración de heridas/Seleccione")]
            ValoracionHeridasTejidoExposicion = 55,
            [Description("Valoración de heridas/Exudado")]
            ValoracionHeridasExudado = 56,
            [Description("Valoración de heridas/Tipo exudado")]
            ValoracionHeridasTipoExudado = 57,
            [Description("Valoración de heridas/Piel Circundante")]
            ValoracionHeridasPielCircundante = 58,
            [Description("Valoración de heridas/Bordes de la herida")]
            ValoracionHeridasBordesHerida = 59,
            [Description("Valoración de heridas/Olor")]
            ValoracionHeridasOlor = 60,
            [Description("Valoración de heridas/Signos y sintomas")]
            ValoracionHeridasSignosSintomas = 61,
            [Description("Valoración de heridas/Componente educativo")]
            ValoracionHeridasComponenteEducativo = 62,
            [Description("Evolución manejo de heridas/Piel perilesional")]
            EvolucionManejoHeridasPielPerilesional = 63,
            [Description("Evolución manejo de heridas/Signos de infección")]
            EvolucionManejoHeridasSignosInfeccion = 64,
            [Description("Evolución manejo de heridas/Tipo cambios locales de herida")]
            EvolucionManejoHeridasTipoCambioLocal = 65,
            [Description("Evolución manejo de heridas/Indicaciones terapeuticas")]
            EvolucionManejoHeridasIndicacionesTerapeuticas = 66,
            [Description("Evolución manejo de heridas/Componente educativo")]
            EvolucionManejoHeridasComponenteEducativo = 67,
            [Description("Valoración de heridas/Definición exudado")]
            ValoracionHeridasClasificacionExudado = 68,
            [Description("Valoración de heridas/Seguridad paciente")]
            ValoracionHeridasSeguridadPaciente = 69,
            [Description("Valoración de heridas/Localización 2")]
            ValoracionHeridasLocalizacion2 = 70,
            [Description("Valoración de heridas/Localización 3")]
            ValoracionHeridasLocalizacion3 = 71,
            [Description("Valoración de heridas/Mi")]
            ValoracionHeridasMI = 72,
            [Description("Valoración de heridas/Pies")]
            ValoracionHeridasPies = 73,
            [Description("Facturación/Causal devolución")]
            FacturaciónCausalDevolucion = 74,
            [Description("Facturación/Causal glosa")]
            FacturaciónCausalGlosa = 75,
            [Description("Índices o escalas/Cruz Roja")]
            IndiceEscalaCruzRoja = 76,
            [Description("Índices o escalas/Norton")]
            IndiceEscalaNorton = 78,
            [Description("Recursos humanos/Empresas en las que labora actualmente")]
            RecursosHumanosEmpresas = 80,
            [Description("Recursos humanos/Cursos")]
            RecursosHumanosCursos = 81,
            [Description("OrganizationExample16 - atención/Tipo paciente")]
            OrganizationExample16AtencionTipoPaciente = 82,
            [Description("Farmacia/Centro de costos")]
            FarmaciaCentroCosto = 83,
            [Description("Recursos humanos/Origen Tarjeta profesional")]
            RecursosHumanosOrigenTP = 84,
            [Description("Valoración enfermería/Patrón de percepción y cuidado de la salud")]
            ValoracionEnfermeriaPatronPercepcion = 85,
            [Description("Valoración enfermería/Patrón nutricional y metabólico")]
            ValoracionEnfermeriaPatronNutricional = 87,
            [Description("Valoración enfermería/Patrón de eliminación")]
            ValoracionEnfermeriaPatronEliminacion = 88,
            [Description("Valoración enfermería/Patrón actividad y ejercicio")]
            ValoracionEnfermeriaPatronActividad = 89,
            [Description("Valoración enfermería/Patrón sueño y descanso")]
            ValoracionEnfermeriaPatronSueno = 90,
            [Description("Valoración enfermería/Patrón cognitivo perceptual")]
            ValoracionEnfermeriaPatronCognitivo = 91,
            [Description("Valoración enfermería/Patrón autopercepción y auto concepto 2")]
            ValoracionEnfermeriaPatroAutopercepcion2 = 92,
            [Description("Valoración enfermería/Patrón función y relación")]
            ValoracionEnfermeriaPatronFuncionRelacion = 93,
            [Description("Valoración enfermería/Patrón de afrontamiento y tolerancia al stress")]
            ValoracionEnfermeriaPatronAfrontamiento = 94,
            [Description("Valoración enfermería/Patrón de valores y creencias")]
            ValoracionEnfermeriaPatronValores = 95,
            [Description("Valoración enfermería/Patrón autopercepción y auto concepto 1")]
            ValoracionEnfermeriaPatroAutopercepcion1 = 96,
            [Description("Valoración trabajo social/Tipología familiar")]
            ValoracionTrabajoSocialTipologiaFamiliar = 97,
            [Description("Valoración trabajo social/Como afronta la familia las dificultades?")]
            ValoracionTrabajoSocialAfrontaDificultades = 98,
            [Description("Valoración trabajo social/Tenencia")]
            ValoracionTrabajoSocialTenencia = 99,
            [Description("Valoración trabajo social/Tipo de vivienda")]
            ValoracionTrabajoSocialTipoVivienda = 100,
            [Description("Valoración trabajo social/Condiciones de la vivienda")]
            ValoracionTrabajoSocialCondicionesVivienda = 101,
            [Description("Valoración trabajo social/Pisos")]
            ValoracionTrabajoSocialPisos = 102,
            [Description("Valoración trabajo social/Estructura")]
            ValoracionTrabajoSocialEstrucutura = 103,
            [Description("Valoración trabajo social/Espacios")]
            ValoracionTrabajoSocialEspacios = 104,
            [Description("Valoración trabajo social/Servicios públicos")]
            ValoracionTrabajoSocialServiciosPublicos = 105,
            [Description("Valoración trabajo social/Ingresos mensuales")]
            ValoracionTrabajoSocialIngresosMensuales = 106,
            [Description("Valoración trabajo social/Egresos mensuales")]
            ValoracionTrabajoSocialEgresosMensuales = 107,
            [Description("Valoración trabajo social/Varios")]
            ValoracionTrabajoSocialVarios = 108,
            [Description("Valoración Psicología/Motivo consulta ")]
            ValoracionPsicologicaMotivoConsulta = 109,
            [Description("Valoración Psicología/Motivo consulta problema")]
            ValoracionPsicologicaMotivoConsultaProblema = 110,
            [Description("Valoración Psicología/Perfil histórico de desarrollo y funcionamiento")]
            ValoracionPsicologicaPerfilHistorico = 112,
            [Description("Valoración Psicología/Porte")]
            ValoracionPsicologicaPorte = 113,
            [Description("Valoración Psicología/Actitud")]
            ValoracionPsicologicaActitud = 114,
            [Description("Valoración Psicología/Conciencia")]
            ValoracionPsicologicaConciencia = 115,
            [Description("Valoración Psicología/Orientación")]
            ValoracionPsicologicaOrientacion = 116,
            [Description("Valoración Psicología/Memoria")]
            ValoracionPsicologicaMemoria = 117,
            [Description("Valoración Psicología/Atención")]
            ValoracionPsicologicaAtencion = 118,
            [Description("Valoración Psicología/Pensamiento")]
            ValoracionPsicologicaPensamiento = 119,
            [Description("Valoración Psicología/Curso")]
            ValoracionPsicologicaCurso = 120,
            [Description("Valoración Psicología/Contenido")]
            ValoracionPsicologicaContenido = 121,
            [Description("Valoración Psicología/Afecto")]
            ValoracionPsicologicaAfecto = 122,
            [Description("Valoración Psicología/Afecto (Tono)")]
            ValoracionPsicologicaAfectoTono = 123,
            [Description("Valoración Psicología/Sensopercepción")]
            ValoracionPsicologicaSensopercepcion = 124,
            [Description("Valoración Psicología/Conducta Motora")]
            ValoracionPsicologicaConductaMotora = 125,
            [Description("Valoración Psicología/Inteligencia")]
            ValoracionPsicologicaInteligencia = 126,
            [Description("Valoración Psicología/Lenguaje verbal")]
            ValoracionPsicologicaLenguajeVerbal = 127,
            [Description("Valoración Psicología/Lenguaje escrito")]
            ValoracionPsicologicaLenguajeEscrito = 128,
            [Description("Valoración Psicología/Lenguaje mímico")]
            ValoracionPsicologicaLenguajeMimico = 129,
            [Description("Valoración Psicología/Sueño")]
            ValoracionPsicologicaSueno = 130,
            [Description("Valoración Psicología/Conducta Alimentaria")]
            ValoracionPsicologicaConductaAlimentaria = 131,
            [Description("Valoración Psicología/Conducta Sexual")]
            ValoracionPsicologicaConductaSexual = 132,
            [Description("Valoración Psicología/Introspección")]
            ValoracionPsicologicaInstropeccion = 133,
            [Description("Valoración Psicología/Prospección")]
            ValoracionPsicologicaProspeccion = 134,
            [Description("Valoración Psicología/Juicio")]
            ValoracionPsicologicaJuicio = 135,
            [Description("Valoración Psicología/Impresión diagnóstica")]
            ValoracionPsicologicaImpresionDiagnostica = 136,
            [Description("Valoración Psicología/Plan de tratamiento")]
            ValoracionPsicologicaPlanTratamiento = 137,
            [Description("Archivo/Tipo")]
            ArchivoTipo = 138,
            [Description("Paciente/Ciudad")]
            Ciudad = 139,
            [Description("Farmacia/Zonas")]
            FarmaciaZona = 140,
            [Description("Seguimiento Materno/Motivo de consulta")]
            SeguimientoMaternoMotivoConsulta = 141,
            [Description("Seguimiento Materno/Riesgo psicisocial")]
            SeguimientoMaternoRiesgoPsicisocial = 142,
            [Description("Seguimiento Materno/Antecedentes 1")]
            SeguimientoMaternoAntecedentes1 = 143,
            [Description("Seguimiento Materno/Antecedentes 2")]
            SeguimientoMaternoAntecedentes2 = 144,
            [Description("Seguimiento Materno/Antecedentes 3")]
            SeguimientoMaternoAntecedentes3 = 145,
            [Description("Seguimiento Materno/Antecedentes obstetrica")]
            SeguimientoMaternoAntecedentesObstetrica = 147,
            [Description("Seguimiento Materno/Revisión por sistemas")]
            SeguimientoMaternoRevisionSistemas = 148,
            [Description("Seguimiento Materno/Resultados laboratorios")]
            SeguimientoMaternoResultadosLaboratorios = 150,
            [Description("Seguimiento Materno/Resultados ecografías")]
            SeguimientoMaternoResultadosEcografias = 151,
            [Description("Seguimiento Materno/Examen físico")]
            SeguimientoMaternoExamenFisico = 152,
            [Description("Seguimiento Materno/Abdomen")]
            SeguimientoMaternoAbdomen = 153,
            [Description("Seguimiento Materno/Miembros inferiores")]
            SeguimientoMaternoMiembrosInferiores = 154,
            [Description("Seguimiento Materno/Plan de manejo")]
            SeguimientoMaternoPlanManejo = 155,
            [Description("Seguimiento posparto/Motivo de consulta")]
            SeguimientoPospartoMotivoConsulta = 156,
            [Description("Seguimiento posparto/Antecedentes 1")]
            SeguimientoPospartoAntecedentes1 = 157,
            [Description("Seguimiento posparto/Antecedentes 2")]
            SeguimientoPospartoAntecedentes2 = 158,
            [Description("Seguimiento posparto/Revisión por sistemas")]
            SeguimientoPospartoRevisionPorSistemas = 159,
            [Description("Seguimiento posparto/Examen físico senos")]
            SeguimientoPospartoExamenFisicoSenos = 160,
            [Description("Seguimiento posparto/Examen físico abdomen")]
            SeguimientoPospartoExamenFisicoAbdomen = 161,
            [Description("Paciente/IPS")]
            IPS = 162,
            [Description("Bitácoras/Estado")]
            BitacorasEstado = 163,
            [Description("MIPRES/Servicios")]
            MIPRESServicios = 164,
            [Description("Neonatos/Valoración de la madre")]
            NeonatosValoracionMadre = 165,
            [Description("Neonatos/Sintomas de vasos espasmo")]
            NeonatosSintomasVasoEspasmos = 166,
            [Description("Neonatos/Senos")]
            NeonatosSenos = 167,
            [Description("Neonatos/Abdomen")]
            NeonatosAbdomen = 168,
            [Description("Neonatos/Miembros inferiores")]
            NeonatosMiembrosInferiores = 169,
            [Description("Neonatos/Valoración del recien nacido")]
            NeonatosValoresRecienNacido = 170,
            [Description("Neonatos/Antecedentes del recien nacido")]
            NeonatosAntecedentesRecienNacido = 171,
            [Description("Neonatos/Controles")]
            NeonatosControles = 172,
            [Description("Neonatos/Cuidados del recien nacido")]
            NeonatosCuidados = 173,
            [Description("Neonatos/Lactancia materna")]
            NeonatosLactancia = 174,
            [Description("Neonatos/Antecedentes para el embarazo")]
            NeonatosAntecendetesEmbarazo = 175,
            [Description("Neonatos/Antecedentes")]
            NeonatosAntecedentes = 176,
            [Description("Neonatos/Antecedentes transfuncionales")]
            NeonatosAntecedentesTransfuncionales = 177,
            [Description("Apoyo Terapeutico/Estado cuenta")]
            ApoyoTerapeuticoEstadoCuenta = 178,
            [Description("OrganizationExample16 - Programación/Programa")]
            OrganizationExample16ProgramacionPrograma = 10017,
            [Description("OrganizationExample16 - Programación/Actividad")]
            OrganizationExample16ProgramacionActividad = 10018,
            [Description("OrganizationExample16 - Programación/Plan")]
            OrganizationExample16ProgramacionPlan = 10019,
            [Description("OrganizationExample16 - Programación/Lugar")]
            OrganizationExample16ProgramacionLugar = 10020
        }

        public string Id { get; set; }
        [Required(ErrorMessage = "Por favor ingrese un nombre")]
        public string Nombre { get; set; }
        public string Descripcion { get; set; }
        public Tipo _Tipo { get; set; }
        public string szReservado {get;set;}
        public ulong? parametro1 { get; set; }
        public long? estado { get; set; }

        protected static List<MVarios> _GetItems(string condition, params object[] args)
        {
            List<MVarios> list = new List<MVarios>();
            using (CConector conector = new CConector())
            {
                Query query = new Query("varios");

                query += "id";
                query += "nombre";
                query += "descripcion";
                query += "tipo";
                query += "szReservado";
                query += "parametro1";
                query += "estado";

                MySqlDataReader reader = conector.Query(query.GetSelect(condition + " ORDER BY nombre", null, args));
                if (reader != null)
                {
                    while (reader.Read())
                    {
                        MVarios item = new MVarios();
                        item.Id = reader["id"].ToString();
                        item.Nombre = reader["nombre"].ToString();
                        item.Descripcion = reader["descripcion"].ToString();
                        item._Tipo = (Tipo)(int)reader["tipo"];
                        item.szReservado = reader["szReservado"] as string;
                        item.parametro1 = reader["parametro1"] as ulong?;
                        item.estado = reader["estado"] as long?;
                        list.Add(item);
                    }
                }
                else return null;
            }
            return list;
        }

        public static MVarios GetItem(uint? id)
        {
            return MVarios.GetItem(id?.ToString());
        }

        public static MVarios GetItem(uint id) {
            return MVarios.GetItem(id.ToString());
        }

        public static MVarios GetItem(string id)
        {
            if (string.IsNullOrEmpty(id))
                return new MVarios();
            string key = string.Format("{0}_{1}", "Varios", id);
            MVarios item = Cache.Get<MVarios>(key);
            if (item == null)
            {
                item = _GetItems("id={0}", Query.GetValor(id))?.FirstOrDefault() ?? new MVarios();
                Cache.Set(key, item);
            }
            return item;
        }

        public static List<MVarios> GetList(Tipo tipo)
        {
            string key = string.Format("{0}", "Varios");
            string keylist = string.Format("{0}list", "Varios");
            List<MVarios> list = Cache.Get<List<MVarios>>(key);
            if (list == null)
            {
                list = _GetItems("tipo={0} AND eliminado IS NULL", (int)tipo) ?? new List<MVarios>();
                Cache.Set(key, list);
                Cache.AddList(keylist, key);
            }
            return list;
        }

        public static void CleanCache(string id = null)
        {
            string key = string.Format("{0}_{1}", "Varios", id);
            string keylist = string.Format("{0}list", "Varios");
            Cache.Remove(key);
            Cache.RemoveList(keylist);
        }
    }
}