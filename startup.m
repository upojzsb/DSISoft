%startup file for MATLAB
%codedir='/mnt/adam/dsisoft/'; %replace with working directory UNIX
codedir='I:\zjb\dsisoftv3\'; %replace with working directory WINDOWS

%specify search paths for DSIsoft modules
path(path,codedir);
path(path,[codedir,'aspec']);
path(path,[codedir,'plotheaders']);
path(path,[codedir,'picker']);
path(path,[codedir,'display']);
path(path,[codedir,'demos']);
path(path,[codedir,'demos2']);
path(path,[codedir,'main']);
path(path,[codedir,'fkfilter']);
path(path,[codedir,'qc_dsi']);
path(path,[codedir,'cdpt3d']);
clear codedir

%$Id: startup.m,v 3.0 2000/06/13 19:17:33 gilles Exp $
%$Log: startup.m,v $
%Revision 3.0  2000/06/13 19:17:33  gilles
%Release 3
%
%Revision 2.3  2000/06/13 17:30:32  gilles
%*** empty log message ***
%
%Revision 2.2  1999/06/18 18:32:56  mah
%updating dir
%
%Revision 2.1  1999/05/28 14:32:39  mah
%updated dir
%
%Revision 2.0  1999/05/21 18:40:39  mah
%Release 2
%
%Revision 1.2  1999/05/13 19:20:31  mah
%added demos2
%
%Revision 1.1  1999/01/11 13:44:29  kay
%Initial revision
%
