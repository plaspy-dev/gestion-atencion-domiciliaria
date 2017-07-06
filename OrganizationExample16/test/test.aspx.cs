using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class test_test : System.Web.UI.Page
{
    /*public class PositionWrapperStream : Stream
    {
        private readonly Stream wrapped;

        private long pos = 0;

        public PositionWrapperStream(Stream wrapped)
        {
            this.wrapped = wrapped;
        }

        public override bool CanSeek
        {
            get { return false; }
        }

        public override bool CanWrite
        {
            get { return true; }
        }

        public override long Position
        {
            get { return pos; }
            set { throw new NotSupportedException(); }
        }

        public override bool CanRead
        {
            get { return wrapped.CanRead; }
        }

        public override long Length
        {
            get { return wrapped.Length; }
        }

        public override void Write(byte[] buffer, int offset, int count)
        {
            if (count == 0)
                return;
            pos += count;
            wrapped.Write(buffer, offset, count);
        }

        public override void Flush()
        {
            wrapped.Flush();
        }

        protected override void Dispose(bool disposing)
        {
            wrapped.Dispose();
            base.Dispose(disposing);
        }

        public override long Seek(long offset, SeekOrigin origin)
        {
            switch (origin)
            {
                case SeekOrigin.Begin:
                    pos = 0;
                    break;
                case SeekOrigin.End:
                    pos = Length - 1;
                    break;
            }
            pos += offset;
            return wrapped.Seek(offset, origin);
        }

        public override void SetLength(long value)
        {
            wrapped.SetLength(value);
        }

        public override int Read(byte[] buffer, int offset, int count)
        {
            pos += offset;
            int result = wrapped.Read(buffer, offset, count);
            pos += count;
            return result;
        }
    }*/

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void BTEst_Click(object sender, EventArgs e)
    {
        /*Response.Clear();
        Response.ContentEncoding = System.Text.Encoding.UTF8;
        Response.AddHeader("Content-Disposition", "attachment;filename=" + HttpUtility.UrlPathEncode("file.zip"));
        Response.ContentType = "application/zip";

        using (PositionWrapperStream outputStream = new PositionWrapperStream(Response.OutputStream))
        using (ZipArchive zipArchive = new ZipArchive(outputStream, ZipArchiveMode.Create))
        {
            string fullPath = Server.MapPath("~/xlsx/");
            foreach (string fileName in GetFileList(fullPath))
            {
                ZipArchiveEntry zipEntry = zipArchive.CreateEntry(fileName.Replace(fullPath, ""));
                using (Stream zipStream = zipEntry.Open())
                {
                    string fileContent = File.ReadAllText(fileName);
                    if (!Response.IsClientConnected)
                    {
                        break;
                    }
                }
                Response.Flush();
            }
            Response.Flush();
        }

        Response.End();*/
    }

    public static List<string> GetFileList(string parentPath)
    {
        List<string> Files = new List<string>();
        Files.AddRange(Directory.GetFiles(parentPath));
        foreach (string directory in Directory.GetDirectories(parentPath))
        {
            Files.AddRange(GetFileList(directory));
        }
        return Files;
    }
}