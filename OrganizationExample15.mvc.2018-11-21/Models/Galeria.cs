using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using SDG.Componentes;

namespace OrganizationExample15.Models
{
    public class Galeria
    {
        public FileStorage.Types Tipo { get; set; }
        public List<string> Files { get; set; } = new List<string>();
        public string TipoN {
            get {
                return Tipo.ToString();
            }
        }
        public string Path { get; set; }
        public string AddedFiles { get; set; }
        public string DeletedFiles { get; set; }
        public bool CanDelete { get; set; }
        public bool CanUpload { get; set; }
        [JsonIgnore]
        public List<string> FileType { get; set; } = FileStorage.ValidImagesPDF;
        [JsonIgnore]
        public string FileMimeTypes { get; set; } = FileStorage.ValidMimeImagesPDF;

        public string Params {
            get {
                return Crypt.Protect(JsonConvert.SerializeObject(
                    new FileParam
                    {
                        ValidExtensions = FileType,
                        Path = Path,
                        Tipo = Tipo
                    }, HomeCareVersion.jsonSerializerSettings));
            }
        }

        [JsonIgnore]
        public List<string> _DeletedFiles {
            get {
                return (DeletedFiles ?? "").Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
            }
        }
        [JsonIgnore]
        public List<string> _AddedFiles
        {
            get
            {
                return (AddedFiles ?? "").Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).ToList();
            }
        }
    }
}