using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Znode.Engine.klaviyo.Client;

namespace Znode.WebStore.Custom
{
    public static class PHHelper
    {
        public static Engine.klaviyo.Models.KlaviyoModel GetKlaviyoConfig(int portalId)
        {
            return new KlaviyoClient()?.GetKlaviyo(portalId);
        }

        public static void WriteLog(string strValue)
        {
            try
            {
                string basepath = AppDomain.CurrentDomain.BaseDirectory + "/PHLogs/";
                // create directory if not exists
                Directory.CreateDirectory(basepath);

                //Logfile
                string path = basepath + "phlog_" + DateTime.Now.ToString("dd-MM-yyyy") + ".txt";/// Server.MapPath("\textlog.txt");
                using (StreamWriter sw = File.AppendText(path))
                {
                    sw.WriteLine(DateTime.Now.ToString("dd-MM-yyyy hh:mm::ss tt =>") + strValue);
                }

                //Delete old log files
                Directory.GetFiles(basepath).Select(f => new FileInfo(f)).Where(f => f.CreationTime < DateTime.Now.AddDays(-30)).ToList().ForEach(f => f.Delete());
            }
            catch (Exception ex)
            {

            }
        }

        public static void WriteLog(Exception ex)
        {
            WriteLog(ex?.Message + "\r\n" + ex?.StackTrace);
        }
    }
}
