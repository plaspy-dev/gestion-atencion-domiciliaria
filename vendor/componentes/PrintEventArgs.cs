using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Text;

namespace SDG.Componentes
{
    public class StringBuilderEx
    {
        public StringBuilder StringBuilder { get; set; }
        public StringBuilderEx()
        {
            StringBuilder = new StringBuilder();
        }

        public StringBuilderEx(string value)
        {
            StringBuilder = new StringBuilder(value);
        }

        public StringBuilderEx(StringBuilder value)
        {
            StringBuilder = value;
        }

        public StringBuilderEx Append(object value)
        {
            StringBuilder.Append(value);
            return this;
        }

        public StringBuilderEx Replace(string oldValue, string newValue)
        {
            StringBuilder.Replace(oldValue, newValue);
            return this;
        }

        public static StringBuilderEx operator +(StringBuilderEx This, string stringB)
        {
            return This.Append(stringB);
        }

        public static implicit operator StringBuilderEx(string value) {

            return new StringBuilderEx(value);
        }

        public static implicit operator StringBuilderEx(StringBuilder value)
        {
            return new StringBuilderEx(value);
        }

        public static implicit operator StringBuilder (StringBuilderEx value)
        {
            return value.StringBuilder;
        }

        public override string ToString()
        {
            return StringBuilder.ToString();
        }

        public bool Contains(string value) {

            return StringBuilder.Contains(value);
        }

        public int IndexOf(string value) {
            return StringBuilder.IndexOf(value);
        }

        public int IndexOf(string value, int startPosition) {
            return StringBuilder.IndexOf(value, startPosition);
        }

        public string Substring(int startIndex) { 

            return Substring(startIndex, StringBuilder.Length-startIndex);
        }
        public string Substring(int startIndex, int length) { 
            return StringBuilder.ToString(startIndex, length);
        }

        public StringBuilderEx Insert(int index, string value) {

            StringBuilder= StringBuilder.Insert(index, value);
            return this;
        }
    };

    public static class StringBuilderExtension {

        // Adds IndexOf, Substring, AreEqual to the StringBuilder class.
        public static int IndexOf(this StringBuilder theStringBuilder, string value)
        {
            const int NOT_FOUND = -1;
            if (theStringBuilder == null)
            {
                return NOT_FOUND;
            }
            if (String.IsNullOrEmpty(value))
            {
                return NOT_FOUND;
            }
            int count = theStringBuilder.Length;
            int len = value.Length;
            if (count < len)
            {
                return NOT_FOUND;
            }
            int loopEnd = count - len + 1;
            for (int loop = 0; loop < loopEnd; loop++)
            {
                bool found = true;
                for (int innerLoop = 0; innerLoop < len; innerLoop++)
                {
                    if (theStringBuilder[loop + innerLoop] != value[innerLoop])
                    {
                        found = false;
                        break;
                    }
                }
                if (found)
                {
                    return loop;
                }
            }
            return NOT_FOUND;
        }

        public static int IndexOf(this StringBuilder theStringBuilder, string value, int startPosition)
        {
            const int NOT_FOUND = -1;
            if (theStringBuilder == null)
            {
                return NOT_FOUND;
            }
            if (String.IsNullOrEmpty(value))
            {
                return NOT_FOUND;
            }
            int count = theStringBuilder.Length;
            int len = value.Length;
            if (count < len)
            {
                return NOT_FOUND;
            }
            int loopEnd = count - len + 1;
            if (startPosition >= loopEnd)
            {
                return NOT_FOUND;
            }
            for (int loop = startPosition; loop < loopEnd; loop++)
            {
                bool found = true;
                for (int innerLoop = 0; innerLoop < len; innerLoop++)
                {
                    if (theStringBuilder[loop + innerLoop] != value[innerLoop])
                    {
                        found = false;
                        break;
                    }
                }
                if (found)
                {
                    return loop;
                }
            }
            return NOT_FOUND;
        }

        // Adds IndexOf, Substring, AreEqual to the StringBuilder class.
        public static bool Contains(this StringBuilder theStringBuilder, string value)
        {
            if (theStringBuilder == null)
            {
                return false;
            }
            if (String.IsNullOrEmpty(value))
            {
                return false;
            }
            int count = theStringBuilder.Length;
            int len = value.Length;
            if (count < len)
            {
                return false;
            }
            int loopEnd = count - len + 1;
            for (int loop = 0; loop < loopEnd; loop++)
            {
                bool found = true;
                for (int innerLoop = 0; innerLoop < len; innerLoop++)
                {
                    if (theStringBuilder[loop + innerLoop] != value[innerLoop])
                    {
                        found = false;
                        break;
                    }
                }
                if (found)
                {
                    return true;
                }
            }
            return false;
        }
    }

    public class PrintEventArgs : EventArgs
    {
        public enum PrintType {
            HTML,
            PDF,
            XML
        };
        // public StringBuilderEx Contenido = new StringBuilderEx();
        public StringBuilderEx Contenido = new StringBuilderEx();
        public bool pdf { get {
                return Type == PrintType.PDF;
            }
        }
        public PrintType Type { get; set; }
        public bool Cancel { get; set; }

        public PrintEventArgs() { }
        public PrintEventArgs(bool pdf) {
            if (pdf)
                Type = PrintType.PDF;
        }
        public PrintEventArgs(PrintType type) {
            Type = type;
        }
        public void ReplaceVariable(string variable, string valor) {
            Contenido = Contenido.Replace(variable, valor);
        }
    }

}
