using AutoMapper;
using Znode.Admin.Custom.ViewModels;
using Znode.Engine.Admin.ViewModels;
using Znode.Engine.Api.Models;
using Znode.Api.Model.Custom;

namespace Znode.Admin.Custom
{
    public static class CustomAutoMapperConfig
    {
        public static void Execute()
        {
            Mapper.CreateMap<CustomPortalDetailViewModel, CustomPortalDetailModel>().ReverseMap();
            Mapper.CreateMap<StoreFeatureViewModel, PortalFeatureModel>().ReverseMap();
        }
    }
}
