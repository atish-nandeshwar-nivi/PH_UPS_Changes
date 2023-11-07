using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Znode.Api.Model.Custom.CustomUpsModel
{
    public static class CustomUpsSettings
    {
        public static string OauthTokenUrl = Convert.ToString(ConfigurationManager.AppSettings["UPSGatewayURLOAuthToken"]);
        public static string RateUrl = Convert.ToString(ConfigurationManager.AppSettings["UPSGatewayURLRate"]);
        public static string ClientID = Convert.ToString(ConfigurationManager.AppSettings["UPSClientID"]);
        public static string Clientsecret = Convert.ToString(ConfigurationManager.AppSettings["UPSClientsecret"]);
        public static string UPSResponse = null;

    }
}
