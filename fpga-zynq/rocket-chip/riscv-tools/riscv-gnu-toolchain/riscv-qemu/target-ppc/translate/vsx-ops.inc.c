GEN_HANDLER_E(lxsdx, 0x1F, 0x0C, 0x12, 0, PPC_NONE, PPC2_VSX),
GEN_HANDLER_E(lxsiwax, 0x1F, 0x0C, 0x02, 0, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(lxsiwzx, 0x1F, 0x0C, 0x00, 0, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(lxsibzx, 0x1F, 0x0D, 0x18, 0, PPC_NONE, PPC2_ISA300),
GEN_HANDLER_E(lxsihzx, 0x1F, 0x0D, 0x19, 0, PPC_NONE, PPC2_ISA300),
GEN_HANDLER_E(lxsspx, 0x1F, 0x0C, 0x10, 0, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(lxvd2x, 0x1F, 0x0C, 0x1A, 0, PPC_NONE, PPC2_VSX),
GEN_HANDLER_E(lxvdsx, 0x1F, 0x0C, 0x0A, 0, PPC_NONE, PPC2_VSX),
GEN_HANDLER_E(lxvw4x, 0x1F, 0x0C, 0x18, 0, PPC_NONE, PPC2_VSX),

GEN_HANDLER_E(stxsdx, 0x1F, 0xC, 0x16, 0, PPC_NONE, PPC2_VSX),
GEN_HANDLER_E(stxsibx, 0x1F, 0xD, 0x1C, 0, PPC_NONE, PPC2_ISA300),
GEN_HANDLER_E(stxsihx, 0x1F, 0xD, 0x1D, 0, PPC_NONE, PPC2_ISA300),
GEN_HANDLER_E(stxsiwx, 0x1F, 0xC, 0x04, 0, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(stxsspx, 0x1F, 0xC, 0x14, 0, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(stxvd2x, 0x1F, 0xC, 0x1E, 0, PPC_NONE, PPC2_VSX),
GEN_HANDLER_E(stxvw4x, 0x1F, 0xC, 0x1C, 0, PPC_NONE, PPC2_VSX),

GEN_HANDLER_E(mfvsrwz, 0x1F, 0x13, 0x03, 0x0000F800, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(mtvsrwa, 0x1F, 0x13, 0x06, 0x0000F800, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(mtvsrwz, 0x1F, 0x13, 0x07, 0x0000F800, PPC_NONE, PPC2_VSX207),
#if defined(TARGET_PPC64)
GEN_HANDLER_E(mfvsrd, 0x1F, 0x13, 0x01, 0x0000F800, PPC_NONE, PPC2_VSX207),
GEN_HANDLER_E(mtvsrd, 0x1F, 0x13, 0x05, 0x0000F800, PPC_NONE, PPC2_VSX207),
#endif

#define GEN_XX1FORM(name, opc2, opc3, fl2)                              \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0, opc3, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 1, opc3, 0, PPC_NONE, fl2)

#define GEN_XX2FORM(name, opc2, opc3, fl2)                           \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0, opc3, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 1, opc3, 0, PPC_NONE, fl2)

#define GEN_XX3FORM(name, opc2, opc3, fl2)                           \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0, opc3, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 1, opc3, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 2, opc3, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 3, opc3, 0, PPC_NONE, fl2)

#define GEN_XX2IFORM(name, opc2, opc3, fl2)                           \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0, opc3, 1, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 1, opc3, 1, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 2, opc3, 1, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 3, opc3, 1, PPC_NONE, fl2)

#define GEN_XX3_RC_FORM(name, opc2, opc3, fl2)                          \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x00, opc3 | 0x00, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x01, opc3 | 0x00, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x02, opc3 | 0x00, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x03, opc3 | 0x00, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x00, opc3 | 0x10, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x01, opc3 | 0x10, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x02, opc3 | 0x10, 0, PPC_NONE, fl2), \
GEN_HANDLER2_E(name, #name, 0x3C, opc2 | 0x03, opc3 | 0x10, 0, PPC_NONE, fl2)

#define GEN_XX3FORM_DM(name, opc2, opc3) \
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x00, opc3|0x00, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x01, opc3|0x00, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x02, opc3|0x00, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x03, opc3|0x00, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x00, opc3|0x04, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x01, opc3|0x04, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x02, opc3|0x04, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x03, opc3|0x04, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x00, opc3|0x08, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x01, opc3|0x08, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x02, opc3|0x08, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x03, opc3|0x08, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x00, opc3|0x0C, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x01, opc3|0x0C, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x02, opc3|0x0C, 0, PPC_NONE, PPC2_VSX),\
GEN_HANDLER2_E(name, #name, 0x3C, opc2|0x03, opc3|0x0C, 0, PPC_NONE, PPC2_VSX)

GEN_XX2FORM(xsabsdp, 0x12, 0x15, PPC2_VSX),
GEN_XX2FORM(xsnabsdp, 0x12, 0x16, PPC2_VSX),
GEN_XX2FORM(xsnegdp, 0x12, 0x17, PPC2_VSX),
GEN_XX3FORM(xscpsgndp, 0x00, 0x16, PPC2_VSX),

GEN_XX2FORM(xvabsdp, 0x12, 0x1D, PPC2_VSX),
GEN_XX2FORM(xvnabsdp, 0x12, 0x1E, PPC2_VSX),
GEN_XX2FORM(xvnegdp, 0x12, 0x1F, PPC2_VSX),
GEN_XX3FORM(xvcpsgndp, 0x00, 0x1E, PPC2_VSX),
GEN_XX2FORM(xvabssp, 0x12, 0x19, PPC2_VSX),
GEN_XX2FORM(xvnabssp, 0x12, 0x1A, PPC2_VSX),
GEN_XX2FORM(xvnegsp, 0x12, 0x1B, PPC2_VSX),
GEN_XX3FORM(xvcpsgnsp, 0x00, 0x1A, PPC2_VSX),

GEN_XX3FORM(xsadddp, 0x00, 0x04, PPC2_VSX),
GEN_XX3FORM(xssubdp, 0x00, 0x05, PPC2_VSX),
GEN_XX3FORM(xsmuldp, 0x00, 0x06, PPC2_VSX),
GEN_XX3FORM(xsdivdp, 0x00, 0x07, PPC2_VSX),
GEN_XX2FORM(xsredp,  0x14, 0x05, PPC2_VSX),
GEN_XX2FORM(xssqrtdp,  0x16, 0x04, PPC2_VSX),
GEN_XX2FORM(xsrsqrtedp,  0x14, 0x04, PPC2_VSX),
GEN_XX3FORM(xstdivdp,  0x14, 0x07, PPC2_VSX),
GEN_XX2FORM(xstsqrtdp,  0x14, 0x06, PPC2_VSX),
GEN_XX3FORM(xsmaddadp, 0x04, 0x04, PPC2_VSX),
GEN_XX3FORM(xsmaddmdp, 0x04, 0x05, PPC2_VSX),
GEN_XX3FORM(xsmsubadp, 0x04, 0x06, PPC2_VSX),
GEN_XX3FORM(xsmsubmdp, 0x04, 0x07, PPC2_VSX),
GEN_XX3FORM(xsnmaddadp, 0x04, 0x14, PPC2_VSX),
GEN_XX3FORM(xsnmaddmdp, 0x04, 0x15, PPC2_VSX),
GEN_XX3FORM(xsnmsubadp, 0x04, 0x16, PPC2_VSX),
GEN_XX3FORM(xsnmsubmdp, 0x04, 0x17, PPC2_VSX),
GEN_XX2IFORM(xscmpodp,  0x0C, 0x05, PPC2_VSX),
GEN_XX2IFORM(xscmpudp,  0x0C, 0x04, PPC2_VSX),
GEN_XX3FORM(xsmaxdp, 0x00, 0x14, PPC2_VSX),
GEN_XX3FORM(xsmindp, 0x00, 0x15, PPC2_VSX),
GEN_XX2FORM(xscvdpsp, 0x12, 0x10, PPC2_VSX),
GEN_XX2FORM(xscvdpspn, 0x16, 0x10, PPC2_VSX207),
GEN_XX2FORM(xscvspdp, 0x12, 0x14, PPC2_VSX),
GEN_XX2FORM(xscvspdpn, 0x16, 0x14, PPC2_VSX207),
GEN_XX2FORM(xscvdpsxds, 0x10, 0x15, PPC2_VSX),
GEN_XX2FORM(xscvdpsxws, 0x10, 0x05, PPC2_VSX),
GEN_XX2FORM(xscvdpuxds, 0x10, 0x14, PPC2_VSX),
GEN_XX2FORM(xscvdpuxws, 0x10, 0x04, PPC2_VSX),
GEN_XX2FORM(xscvsxddp, 0x10, 0x17, PPC2_VSX),
GEN_XX2FORM(xscvuxddp, 0x10, 0x16, PPC2_VSX),
GEN_XX2FORM(xsrdpi, 0x12, 0x04, PPC2_VSX),
GEN_XX2FORM(xsrdpic, 0x16, 0x06, PPC2_VSX),
GEN_XX2FORM(xsrdpim, 0x12, 0x07, PPC2_VSX),
GEN_XX2FORM(xsrdpip, 0x12, 0x06, PPC2_VSX),
GEN_XX2FORM(xsrdpiz, 0x12, 0x05, PPC2_VSX),

GEN_XX3FORM(xsaddsp, 0x00, 0x00, PPC2_VSX207),
GEN_XX3FORM(xssubsp, 0x00, 0x01, PPC2_VSX207),
GEN_XX3FORM(xsmulsp, 0x00, 0x02, PPC2_VSX207),
GEN_XX3FORM(xsdivsp, 0x00, 0x03, PPC2_VSX207),
GEN_XX2FORM(xsresp,  0x14, 0x01, PPC2_VSX207),
GEN_XX2FORM(xsrsp, 0x12, 0x11, PPC2_VSX207),
GEN_XX2FORM(xssqrtsp,  0x16, 0x00, PPC2_VSX207),
GEN_XX2FORM(xsrsqrtesp,  0x14, 0x00, PPC2_VSX207),
GEN_XX3FORM(xsmaddasp, 0x04, 0x00, PPC2_VSX207),
GEN_XX3FORM(xsmaddmsp, 0x04, 0x01, PPC2_VSX207),
GEN_XX3FORM(xsmsubasp, 0x04, 0x02, PPC2_VSX207),
GEN_XX3FORM(xsmsubmsp, 0x04, 0x03, PPC2_VSX207),
GEN_XX3FORM(xsnmaddasp, 0x04, 0x10, PPC2_VSX207),
GEN_XX3FORM(xsnmaddmsp, 0x04, 0x11, PPC2_VSX207),
GEN_XX3FORM(xsnmsubasp, 0x04, 0x12, PPC2_VSX207),
GEN_XX3FORM(xsnmsubmsp, 0x04, 0x13, PPC2_VSX207),
GEN_XX2FORM(xscvsxdsp, 0x10, 0x13, PPC2_VSX207),
GEN_XX2FORM(xscvuxdsp, 0x10, 0x12, PPC2_VSX207),

GEN_XX3FORM(xvadddp, 0x00, 0x0C, PPC2_VSX),
GEN_XX3FORM(xvsubdp, 0x00, 0x0D, PPC2_VSX),
GEN_XX3FORM(xvmuldp, 0x00, 0x0E, PPC2_VSX),
GEN_XX3FORM(xvdivdp, 0x00, 0x0F, PPC2_VSX),
GEN_XX2FORM(xvredp,  0x14, 0x0D, PPC2_VSX),
GEN_XX2FORM(xvsqrtdp,  0x16, 0x0C, PPC2_VSX),
GEN_XX2FORM(xvrsqrtedp,  0x14, 0x0C, PPC2_VSX),
GEN_XX3FORM(xvtdivdp, 0x14, 0x0F, PPC2_VSX),
GEN_XX2FORM(xvtsqrtdp, 0x14, 0x0E, PPC2_VSX),
GEN_XX3FORM(xvmaddadp, 0x04, 0x0C, PPC2_VSX),
GEN_XX3FORM(xvmaddmdp, 0x04, 0x0D, PPC2_VSX),
GEN_XX3FORM(xvmsubadp, 0x04, 0x0E, PPC2_VSX),
GEN_XX3FORM(xvmsubmdp, 0x04, 0x0F, PPC2_VSX),
GEN_XX3FORM(xvnmaddadp, 0x04, 0x1C, PPC2_VSX),
GEN_XX3FORM(xvnmaddmdp, 0x04, 0x1D, PPC2_VSX),
GEN_XX3FORM(xvnmsubadp, 0x04, 0x1E, PPC2_VSX),
GEN_XX3FORM(xvnmsubmdp, 0x04, 0x1F, PPC2_VSX),
GEN_XX3FORM(xvmaxdp, 0x00, 0x1C, PPC2_VSX),
GEN_XX3FORM(xvmindp, 0x00, 0x1D, PPC2_VSX),
GEN_XX3_RC_FORM(xvcmpeqdp, 0x0C, 0x0C, PPC2_VSX),
GEN_XX3_RC_FORM(xvcmpgtdp, 0x0C, 0x0D, PPC2_VSX),
GEN_XX3_RC_FORM(xvcmpgedp, 0x0C, 0x0E, PPC2_VSX),
GEN_XX2FORM(xvcvdpsp, 0x12, 0x18, PPC2_VSX),
GEN_XX2FORM(xvcvdpsxds, 0x10, 0x1D, PPC2_VSX),
GEN_XX2FORM(xvcvdpsxws, 0x10, 0x0D, PPC2_VSX),
GEN_XX2FORM(xvcvdpuxds, 0x10, 0x1C, PPC2_VSX),
GEN_XX2FORM(xvcvdpuxws, 0x10, 0x0C, PPC2_VSX),
GEN_XX2FORM(xvcvsxddp, 0x10, 0x1F, PPC2_VSX),
GEN_XX2FORM(xvcvuxddp, 0x10, 0x1E, PPC2_VSX),
GEN_XX2FORM(xvcvsxwdp, 0x10, 0x0F, PPC2_VSX),
GEN_XX2FORM(xvcvuxwdp, 0x10, 0x0E, PPC2_VSX),
GEN_XX2FORM(xvrdpi, 0x12, 0x0C, PPC2_VSX),
GEN_XX2FORM(xvrdpic, 0x16, 0x0E, PPC2_VSX),
GEN_XX2FORM(xvrdpim, 0x12, 0x0F, PPC2_VSX),
GEN_XX2FORM(xvrdpip, 0x12, 0x0E, PPC2_VSX),
GEN_XX2FORM(xvrdpiz, 0x12, 0x0D, PPC2_VSX),

GEN_XX3FORM(xvaddsp, 0x00, 0x08, PPC2_VSX),
GEN_XX3FORM(xvsubsp, 0x00, 0x09, PPC2_VSX),
GEN_XX3FORM(xvmulsp, 0x00, 0x0A, PPC2_VSX),
GEN_XX3FORM(xvdivsp, 0x00, 0x0B, PPC2_VSX),
GEN_XX2FORM(xvresp, 0x14, 0x09, PPC2_VSX),
GEN_XX2FORM(xvsqrtsp, 0x16, 0x08, PPC2_VSX),
GEN_XX2FORM(xvrsqrtesp, 0x14, 0x08, PPC2_VSX),
GEN_XX3FORM(xvtdivsp, 0x14, 0x0B, PPC2_VSX),
GEN_XX2FORM(xvtsqrtsp, 0x14, 0x0A, PPC2_VSX),
GEN_XX3FORM(xvmaddasp, 0x04, 0x08, PPC2_VSX),
GEN_XX3FORM(xvmaddmsp, 0x04, 0x09, PPC2_VSX),
GEN_XX3FORM(xvmsubasp, 0x04, 0x0A, PPC2_VSX),
GEN_XX3FORM(xvmsubmsp, 0x04, 0x0B, PPC2_VSX),
GEN_XX3FORM(xvnmaddasp, 0x04, 0x18, PPC2_VSX),
GEN_XX3FORM(xvnmaddmsp, 0x04, 0x19, PPC2_VSX),
GEN_XX3FORM(xvnmsubasp, 0x04, 0x1A, PPC2_VSX),
GEN_XX3FORM(xvnmsubmsp, 0x04, 0x1B, PPC2_VSX),
GEN_XX3FORM(xvmaxsp, 0x00, 0x18, PPC2_VSX),
GEN_XX3FORM(xvminsp, 0x00, 0x19, PPC2_VSX),
GEN_XX3_RC_FORM(xvcmpeqsp, 0x0C, 0x08, PPC2_VSX),
GEN_XX3_RC_FORM(xvcmpgtsp, 0x0C, 0x09, PPC2_VSX),
GEN_XX3_RC_FORM(xvcmpgesp, 0x0C, 0x0A, PPC2_VSX),
GEN_XX2FORM(xvcvspdp, 0x12, 0x1C, PPC2_VSX),
GEN_XX2FORM(xvcvspsxds, 0x10, 0x19, PPC2_VSX),
GEN_XX2FORM(xvcvspsxws, 0x10, 0x09, PPC2_VSX),
GEN_XX2FORM(xvcvspuxds, 0x10, 0x18, PPC2_VSX),
GEN_XX2FORM(xvcvspuxws, 0x10, 0x08, PPC2_VSX),
GEN_XX2FORM(xvcvsxdsp, 0x10, 0x1B, PPC2_VSX),
GEN_XX2FORM(xvcvuxdsp, 0x10, 0x1A, PPC2_VSX),
GEN_XX2FORM(xvcvsxwsp, 0x10, 0x0B, PPC2_VSX),
GEN_XX2FORM(xvcvuxwsp, 0x10, 0x0A, PPC2_VSX),
GEN_XX2FORM(xvrspi, 0x12, 0x08, PPC2_VSX),
GEN_XX2FORM(xvrspic, 0x16, 0x0A, PPC2_VSX),
GEN_XX2FORM(xvrspim, 0x12, 0x0B, PPC2_VSX),
GEN_XX2FORM(xvrspip, 0x12, 0x0A, PPC2_VSX),
GEN_XX2FORM(xvrspiz, 0x12, 0x09, PPC2_VSX),

#define VSX_LOGICAL(name, opc2, opc3, fl2) \
GEN_XX3FORM(name, opc2, opc3, fl2)

VSX_LOGICAL(xxland, 0x8, 0x10, PPC2_VSX),
VSX_LOGICAL(xxlandc, 0x8, 0x11, PPC2_VSX),
VSX_LOGICAL(xxlor, 0x8, 0x12, PPC2_VSX),
VSX_LOGICAL(xxlxor, 0x8, 0x13, PPC2_VSX),
VSX_LOGICAL(xxlnor, 0x8, 0x14, PPC2_VSX),
VSX_LOGICAL(xxleqv, 0x8, 0x17, PPC2_VSX207),
VSX_LOGICAL(xxlnand, 0x8, 0x16, PPC2_VSX207),
VSX_LOGICAL(xxlorc, 0x8, 0x15, PPC2_VSX207),
GEN_XX3FORM(xxmrghw, 0x08, 0x02, PPC2_VSX),
GEN_XX3FORM(xxmrglw, 0x08, 0x06, PPC2_VSX),
GEN_XX2FORM(xxspltw, 0x08, 0x0A, PPC2_VSX),
GEN_XX1FORM(xxspltib, 0x08, 0x0B, PPC2_ISA300),
GEN_XX3FORM_DM(xxsldwi, 0x08, 0x00),

#define GEN_XXSEL_ROW(opc3) \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x18, opc3, 0, PPC_NONE, PPC2_VSX), \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x19, opc3, 0, PPC_NONE, PPC2_VSX), \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x1A, opc3, 0, PPC_NONE, PPC2_VSX), \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x1B, opc3, 0, PPC_NONE, PPC2_VSX), \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x1C, opc3, 0, PPC_NONE, PPC2_VSX), \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x1D, opc3, 0, PPC_NONE, PPC2_VSX), \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x1E, opc3, 0, PPC_NONE, PPC2_VSX), \
GEN_HANDLER2_E(xxsel, "xxsel", 0x3C, 0x1F, opc3, 0, PPC_NONE, PPC2_VSX), \

GEN_XXSEL_ROW(0x00)
GEN_XXSEL_ROW(0x01)
GEN_XXSEL_ROW(0x02)
GEN_XXSEL_ROW(0x03)
GEN_XXSEL_ROW(0x04)
GEN_XXSEL_ROW(0x05)
GEN_XXSEL_ROW(0x06)
GEN_XXSEL_ROW(0x07)
GEN_XXSEL_ROW(0x08)
GEN_XXSEL_ROW(0x09)
GEN_XXSEL_ROW(0x0A)
GEN_XXSEL_ROW(0x0B)
GEN_XXSEL_ROW(0x0C)
GEN_XXSEL_ROW(0x0D)
GEN_XXSEL_ROW(0x0E)
GEN_XXSEL_ROW(0x0F)
GEN_XXSEL_ROW(0x10)
GEN_XXSEL_ROW(0x11)
GEN_XXSEL_ROW(0x12)
GEN_XXSEL_ROW(0x13)
GEN_XXSEL_ROW(0x14)
GEN_XXSEL_ROW(0x15)
GEN_XXSEL_ROW(0x16)
GEN_XXSEL_ROW(0x17)
GEN_XXSEL_ROW(0x18)
GEN_XXSEL_ROW(0x19)
GEN_XXSEL_ROW(0x1A)
GEN_XXSEL_ROW(0x1B)
GEN_XXSEL_ROW(0x1C)
GEN_XXSEL_ROW(0x1D)
GEN_XXSEL_ROW(0x1E)
GEN_XXSEL_ROW(0x1F)

GEN_XX3FORM_DM(xxpermdi, 0x08, 0x01),
