using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;

namespace OrganizationExample15.Models
{
    public class FileParam
    {
        [JsonProperty("t")]
        public FileStorage.Types Tipo { get; set; }
        [JsonProperty("p")]
        public string Path { get; set; }
        [JsonProperty("r")]
        public bool RenameFiles { get; set; }
        [JsonProperty("e")]
        public List<string> ValidExtensions { get; set; }
    }
}