{
 +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is provided 'as-is', without any express or implied
  warranty. In no event will the author be held liable for any damages
  arising from the use of this code.

  However, it is granted that this code may be used for any purpose,
  including commercial applications, but it may not be modified,
  distributed, or sublicensed without express written authorization from
  the author (Talis Jonatas Gomes). This includes creating derivative works
  or distributing the source code through any means.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I D2Bridge.inc}

unit D2Bridge.HTML.CSS;

interface

uses
  Classes,
  Prism.Font.Awesome;


type
 TCSSClassCol = class;
 TCSSClassColAlign = class;
 TCSSClassCard = class;
 TCSSClassImage = class;
 TCSSClassTabsColor = class;
 TCSSClassPanelColor = class;
 TCSSClassDiv = class;
 TCSSClassColor = class;
 TCSSClassButton = class;
 TCSSClassText = class;
 TCSSClassPopup = class;
 TCSSClassColorName = class;
 TCSSClassSpace = class;
 TCSSClassCardGrid = class;


 TCSSClass = class
  private

  public
   Col: TCSSClassCol;
   Card: TCSSClassCard;
   CardGrid: TCSSClassCardGrid;
   Image: TCSSClassImage;
   TabsColor: TCSSClassTabsColor;
   Color: TCSSClassColor;
   ColorName: TCSSClassColorName;
   Button: TCSSClassButton;
   DivHtml: TCSSClassDIV;
   PanelColor: TCSSClassPanelColor;
   Popup: TCSSClassPopup;
   Text: TCSSClassText;
   Font: TCSSFontAwesome;
   Space: TCSSClassSpace;

   constructor Create;
   destructor Destroy; override;
  published

 end;



 {$REGION 'TabsColor'}
 TCSSClassTabsColor = class
  const
   primary = 'card-header-primary';
   secondary = 'card-header-secondary';
   success = 'card-header-success';
   danger = 'card-header-danger';
 end;
 {$ENDREGION}



 {$REGION 'Col'}
 TCSSClassCol = class
  class var
   Align : TCSSClassColAlign;
  const
//text-center e justify-content-center
   col = 'col col-xs-auto';
   colauto = 'col-auto';
   colsizeNumericValue = 'col-xl-2 col-md-4 col-6';
   {$REGION 'Col-xl'}
   colxl = 'col-xl-1';
   colsize1 = 'col-xl-1 col-md-4 col-6';
   colsize2 = 'col-xl-2 col-md-4 col-6';
   colsize3 = 'col-xl-3 col-md-5 col-6';
   colsize4 = 'col-xl-4 col-md-6 col-12';
   colsize5 = 'col-xl-5 col-md-8 col-12';
   colsize6 = 'col-xl-6 col-md-8 col-12';
   colsize7 = 'col-xl-7 col-md-12 col-12';
   colsize8 = 'col-xl-8 col-md-12 col-12';
   colsize9 = 'col-xl-9 col-md-12 col-12';
   colsize10 = 'col-xl-10 col-md-12 col-12';
   colsize11 = 'col-xl-11 col-md-12 col-12';
   colsize12 = 'col-xl-12 col-md-12 col-12';
   colfull = 'col col-xs-auto col-full';
   {$ENDREGION}
   colinline = 'd2bridgecolinline';
   nocolinline = 'd2bridgenocolinline';
 end;

 TCSSClassColAlign = class
  const
   left = 'colalignleft';
   center = 'colaligncenter';
   right = 'colalignright';
 end;
 {$ENDREGION}


 {$REGION 'CARD'}
 TCSSClassCard = class
  const
   Card_Center = 'card-center d2bridgespacemode';
   Card_Center_Small = 'card-center-sm d2bridgespacemode';
   Card_Center_Large = 'card-center-lg d2bridgespacemode';
   Card_Center_ExtraLarge = 'card-center-xl d2bridgespacemode';
   Card_Center_Fullscreen = 'card-center-full d2bridgespacemode';
   Image_Ico = 'card-img-ico';
   Card_Not_Renderizable = 'cardnotrenderizable';
 end;
 {$ENDREGION}


 {$REGION 'CARDGRID'}
 TCSSClassCardGrid = class
  const
   CardGridAuto = 'row-cols-auto';
   CardGridX1 = 'row-cols-1';
   CardGridX2 = 'row-cols-1 row-cols-sm-1 row-cols-md-2 row-cols-lg-2 row-cols-xl-2 row-cols-xxl-3';
   CardGridX3 = 'row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-3 row-cols-xl-3 row-cols-xxl-4';
   CardGridX4 = 'row-cols-1 row-cols-sm-3 row-cols-md-3 row-cols-lg-4 row-cols-xl-4 row-cols-xxl-5';
   CardGridX5 = 'row-cols-2 row-cols-sm-3 row-cols-md-3 row-cols-lg-4 row-cols-xl-5';
   CardGridX6 = 'row-cols-2 row-cols-sm-3 row-cols-md-3 row-cols-lg-5';
 end;
 {$ENDREGION}


 {$REGION 'IMAGE'}
 TCSSClassImage = class
  const
   Image_Banner = 'd2bridgeimagebanner';
   Image_Banner_Small = 'd2bridgeimagebanner-sm';
   Image_Banner_Large = 'd2bridgeimagebanner-lg';
   Image_Banner_ExtraLarge = 'd2bridgeimagebanner-xl';
   Image_Banner_FullHeight = 'd2bridgeimagebanner-full';
   Image_Dark90 = 'image-darken-90';
   Image_Dark80 = 'image-darken-80';
   Image_Dark70 = 'image-darken-70';
   Image_Dark60 = 'image-darken-60';
   Image_Dark50 = 'image-darken-50';
   Image_Dark40 = 'image-darken-40';
   Image_Dark30 = 'image-darken-30';
   Image_Dark20 = 'image-darken-20';
   Image_Dark10 = 'image-darken-10';
   Image_BG_FullSize = 'image-background-fullsize';
   Image_BG90_FullSize = Image_Bg_FullSize + ' ' + Image_Dark90;
   Image_BG80_FullSize = Image_Bg_FullSize + ' ' + Image_Dark80;
   Image_BG70_FullSize = Image_Bg_FullSize + ' ' + Image_Dark70;
   Image_BG60_FullSize = Image_Bg_FullSize + ' ' + Image_Dark60;
   Image_BG50_FullSize = Image_Bg_FullSize + ' ' + Image_Dark50;
   Image_BG40_FullSize = Image_Bg_FullSize + ' ' + Image_Dark40;
   Image_BG30_FullSize = Image_Bg_FullSize + ' ' + Image_Dark30;
   Image_BG20_FullSize = Image_Bg_FullSize + ' ' + Image_Dark20;
   Image_BG10_FullSize = Image_Bg_FullSize + ' ' + Image_Dark10;
   Image_Card_Ico = 'card-img-ico';
   Image_Card_Square = 'card-img-square';
 end;
 {$ENDREGION}


 {$REGION 'PanelColor'}
 TCSSClassPanelColor = class
  const
   default = 'expanel-default';
   primary = 'expanel-primary';
   secondary = 'expanel-secondary';
   success = 'expanel-success';
   danger = 'expanel-danger';
 end;
 {$ENDREGION}


 {$REGION 'Popup'}
 TCSSClassPopup = class
  const
   default = '';
   Small = 'modal-sm';
   Large = 'modal-lg';
   ExtraLarge = 'modal-xl';
   Fullscreen = 'modal-fullscreen';
 end;
 {$ENDREGION}


 {$REGION 'DIV'}
 TCSSClassDiv = class
  const
   row = 'row';
   Align_Right = 'd-flex justify-content-end gap-2';
   Align_Left = 'd-flex justify-content-start gap-2';
   Align_Center = 'd-flex justify-content-center gap-2';
   Align_Between = 'd-flex justify-content-between gap-2';
   Align_Around = 'd-flex justify-content-around gap-2';
 end;
 {$ENDREGION}


 {$REGION 'Color'}
  TCSSClassColor = class
   const
    primary = 'bg-primary';
    secondary = 'bg-secondary';
    success = 'bg-success';
    info = 'bg-info';
    warning = 'bg-warning';
    danger = 'bg-danger';
  end;
 {$ENDREGION}


 {$REGION 'Color Name'}
  TCSSClassColorName = class
   const
    white = 'white';
    black = 'black';
    aqua = 'aqua';
    aliceblue = 'aliceblue';
    antiquewhite = 'antiquewhite';
    azure = 'azure';
    beige = 'beige';
    bisque = 'bisque';
    blanchedalmond = 'blanchedalmond';
    blueviolet = 'blueviolet';
    brown = 'brown';
    burlywood = 'burlywood';
    cadetblue = 'cadetblue';
    chartreuse = 'chartreuse';
    chocolate = 'chocolate';
    coral = 'coral';
    cornflowerblue = 'cornflowerblue';
    cornsilk = 'cornsilk';
    crimson = 'crimson';
    cyan = 'cyan';
    darkblue = 'darkblue';
    darkcyan = 'darkcyan';
    darkgoldenrod = 'darkgoldenrod';
    darkgray = 'darkgray';
    darkgreen = 'darkgreen';
    darkkhaki = 'darkkhaki';
    darkmagenta = 'darkmagenta';
    darkolivegreen = 'darkolivegreen';
    darkorange = 'darkorange';
    darkorchid = 'darkorchid';
    darkred = 'darkred';
    darksalmon = 'darksalmon';
    darkseagreen = 'darkseagreen';
    darkslateblue = 'darkslateblue';
    darkslategray = 'darkslategray';
    darkturquoise = 'darkturquoise';
    darkviolet = 'darkviolet';
    deeppink = 'deeppink';
    deepskyblue = 'deepskyblue';
    dimgray = 'dimgray';
    dodgerblue = 'dodgerblue';
    firebrick = 'firebrick';
    floralwhite = 'floralwhite';
    forestgreen = 'forestgreen';
    gainsboro = 'gainsboro';
    ghostwhite = 'ghostwhite';
    gold = 'gold';
    goldenrod = 'goldenrod';
    gray = 'gray';
    green = 'green';
    greenyellow = 'greenyellow';
    honeydew = 'honeydew';
    hotpink = 'hotpink';
    indianred = 'indianred';
    indigo = 'indigo';
    ivory = 'ivory';
    khaki = 'khaki';
    lavender = 'lavender';
    lavenderblush = 'lavenderblush';
    lawngreen = 'lawngreen';
    lemonchiffon = 'lemonchiffon';
    lightblue = 'lightblue';
    lightcoral = 'lightcoral';
    lightcyan = 'lightcyan';
    lightgoldenrodyellow = 'lightgoldenrodyellow';
    lightgray = 'lightgray';
    lightgreen = 'lightgreen';
    lightpink = 'lightpink';
    lightsalmon = 'lightsalmon';
    lightseagreen = 'lightseagreen';
    lightskyblue = 'lightskyblue';
    lightslategray = 'lightslategray';
    lightsteelblue = 'lightsteelblue';
    lightyellow = 'lightyellow';
    lime = 'lime';
    limegreen = 'limegreen';
    linen = 'linen';
    magenta = 'magenta';
    maroon = 'maroon';
    mediumaquamarine = 'mediumaquamarine';
    mediumblue = 'mediumblue';
    mediumorchid = 'mediumorchid';
    mediumpurple = 'mediumpurple';
    mediumseagreen = 'mediumseagreen';
    mediumslateblue = 'mediumslateblue';
    mediumspringgreen = 'mediumspringgreen';
    mediumturquoise = 'mediumturquoise';
    mediumvioletred = 'mediumvioletred';
    midnightblue = 'midnightblue';
    mintcream = 'mintcream';
    mistyrose = 'mistyrose';
    moccasin = 'moccasin';
    navajowhite = 'navajowhite';
    navy = 'navy';
    oldlace = 'oldlace';
    olive = 'olive';
    olivedrab = 'olivedrab';
    orange = 'orange';
    orangered = 'orangered';
    orchid = 'orchid';
    palegoldenrod = 'palegoldenrod';
    palegreen = 'palegreen';
    paleturquoise = 'paleturquoise';
    palevioletred = 'palevioletred';
    papayawhip = 'papayawhip';
    peachpuff = 'peachpuff';
    peru = 'peru';
    pink = 'pink';
    plum = 'plum';
    powderblue = 'powderblue';
    purple = 'purple';
    rebeccapurple = 'rebeccapurple';
    rosybrown = 'rosybrown';
    royalblue = 'royalblue';
    saddlebrown = 'saddlebrown';
    salmon = 'salmon';
    sandybrown = 'sandybrown';
    seagreen = 'seagreen';
    seashell = 'seashell';
    sienna = 'sienna';
    silver = 'silver';
    skyblue = 'skyblue';
    slateblue = 'slateblue';
    slategray = 'slategray';
    snow = 'snow';
    springgreen = 'springgreen';
    steelblue = 'steelblue';
    tan = 'tan';
    teal = 'teal';
    thistle = 'thistle';
    tomato = 'tomato';
    turquoise = 'turquoise';
    violet = 'violet';
    wheat = 'wheat';
    whitesmoke = 'whitesmoke';
    yellow = 'yellow';
    yellowgreen = 'yellowgreen';
  end;
 {$ENDREGION}

 {$REGION 'Button'}
  TCSSClassButton = class
    private
    {$REGION 'Type'}
    type
     TCSSClassButtonType = class
     private
       {$REGION 'Default'}
       type
        TCSSClassButtonTypeDefault = class
        const
         default = 'btn-default';
         primary = 'btn-primary';
         secondary = 'btn-secondary';
         success = 'btn-success';
         info = 'btn-info';
         warning = 'btn-warning';
         danger = 'btn-danger';
         link = 'btn-light btn-link';
         light = 'btn-light';
         dark = 'btn-dark';
       end;
       {$ENDREGION}

       {$REGION 'Pill'}
       type
        TCSSClassButtonTypePill = class
        const
         default = 'btn-default btn-pill';
         primary = 'btn-primary btn-pill';
         secondary = 'btn-secondary btn-pill';
         success = 'btn-success btn-pill';
         info = 'btn-info btn-pill';
         warning = 'btn-warning btn-pill';
         danger = 'btn-danger btn-pill';
       end;
       {$ENDREGION}

       {$REGION 'Outline'}
       type
        TCSSClassButtonTypeOutline = class
        const
         default = 'btn-outline-default';
         primary = 'btn-outline-primary';
         secondary = 'btn-outline-secondary';
         success = 'btn-outline-success';
         info = 'btn-outline-info';
         warning = 'btn-outline-warning';
         danger = 'btn-outline-danger';
         light = 'btn-outline-light';
         dark = 'btn-outline-dark';
       end;
       {$ENDREGION}

       {$REGION 'Ligth'}
       type
        TCSSClassButtonTypeLight = class
        const
         default = 'btn-default-light';
         primary = 'btn-primary-light';
         secondary = 'btn-secondary-light';
         success = 'btn-success-light';
         info = 'btn-info-light';
         warning = 'btn-warning-light';
         danger = 'btn-danger-light';
       end;
       {$ENDREGION}

       {$REGION 'Color'}
       type
        TCSSClassButtonTypeColor = class
         const
          blue = 'btn-blue';
          cian = 'btn-azure';
          indigo = 'btn-indigo';
          purple = 'btn-purple';
          pink = 'btn-pink';
          red = 'btn-red';
          orange = 'btn-orange';
          yellow = 'btn-yellow';
          lime = 'btn-lime';
          green = 'btn-green';
          tiffany = 'btn-teal';
          gray = 'btn-gray';
          dark = 'btn-gray-dark';
        end;
       {$ENDREGION}
     public
      Default: TCSSClassButtonTypeDefault;
      Pill: TCSSClassButtonTypePill;
      Outline: TCSSClassButtonTypeOutline;
      Light: TCSSClassButtonTypeLight;
      Color: TCSSClassButtonTypeColor;
     end;

     {$REGION 'Heigth'}
     type
      TCSSClassButonHeigth = class
      const
       small = 'btn-sm';
       large = 'btn-lg';
      end;
     {$ENDREGION}

     {$REGION 'Width'}
     type
      TCSSClassButonWidth = class
      const
       softlarger = 'w-sx';
       large = 'w-sm';
       verylarge = 'w-md';
       extralarge = 'w-lg';
      end;
     {$ENDREGION}

    public
     class var
      TypeButton: TCSSClassButtonType;
      Heigth: TCSSClassButonHeigth;
      Width: TCSSClassButonWidth;
     const
      //fa icons -> https://dropways.github.io/feathericons/
      //fe icons -> https://fontawesome.com/search?m=free
      disabled = 'disabled';
      edit = 'btn-warning [override-button-fa fa-edit]';
      save = 'btn-success [override-button-fa fa-save]';
      cancel = 'btn-warning [override-button-fa fa-x]';
      delete = 'btn-danger [override-button-fa fa-trash]';
      close = 'btn-secondary [override-button-fa fa-sign-out]';
      search = 'btn-primary [override-button-fa fa-search]';
      open = 'btn-primary [override-button-fa fa-external-link]';
      select = 'btn-primary [override-button-fa fa-check-square]';
      decrease = 'btn-danger [override-button-fa fa-minus]';
      increase = 'btn-success [override-button-fa fa-plus]';
      more = 'btn-success [override-button-fa fa-plus]';
      add = 'btn-success [override-button-fa fa-plus]';
      options = 'btn-primary [override-button-fa fa-sliders]';
      config = 'btn-secondary [override-button-fa fa-cog]';
      menu = 'btn-info [override-button-fa fa-menu]';
      refresh = 'btn-primary [override-button-fa fa-refresh]';
      clean = 'btn-warning [override-button-fa fa-broom]';
      cut = 'btn-primary [override-button-fa fa-scissors]';
      copy = 'btn-primary [override-button-fa fa-copy]';
      share = 'btn-primary [override-button-fa fa-share-nodes]';
      powerOn = 'btn-success [override-button-fa fa-power-off]';
      powerOff = 'btn-danger [override-button-fa fa-power-off]';
      start = 'btn-success [override-button-fa-solid fa-play]';
      stop = 'btn-danger [override-button-fa fa-stop]';
      print = 'btn-info [override-button-fa fa-print]';
      view = 'btn-info [override-button-fa-solid fa-eye]';
      hide = 'btn-secondary [override-button-fa-solid fa-eye-slash]';
      upload = 'btn-primary [override-button-fa fa-upload]';
      download = 'btn-primary [override-button-fa fa-cloud-download-alt]';
      send = 'btn-success [override-button-fa fa-paper-plane]';
      mail = 'btn-primary [override-button-fa fa-envelope]';
      mailopen = 'btn-primary [override-button-fa fa-envelope-open]';
      reply = 'btn-primary [override-button-fa fa-reply]';
      code = 'btn-primary [override-button-fa fa-code]';
      key = 'btn-primary [override-button-fa fa-key]';
      check = 'btn-primary [override-button-fa fa-check]';
      uncheck = 'btn-primary [override-button-fa fa-xmark]';
      cart = 'btn-success [override-button-fa-solid fa-cart-shopping]';
      shop = 'btn-success [override-button-fa-solid fa-bag-shopping]';
      shipping = 'btn-success [override-button-fa-solid fa-truck]';
      shipping2 = 'btn-success [override-button-fa-solid fa-truck-fast]';
      cargo = 'btn-primary [override-button-fa-solid fa-dolly]';
      money = 'btn-success [override-button-fa-regular fa-money-check-dollar]';
      card = 'btn-success [override-button-fa-regular fa-credit-card]';
      next = 'btn-success [override-button-r-fa-solid fa-circle-right ms-2]';
      back = 'btn-primary [override-button-fa-solid fa-circle-left]';
      google = 'btn-primary [override-button-fa-brands fa-google]';
      microsoft = 'btn-primary [override-button-fa-brands fa-microsoft]';
      apple = 'btn-primary [override-button-fa-brands fa-apple]';
      facebook = 'btn-primary [override-button-fa-brands fa-facebook]';
      instagram = 'btn-primary [override-button-fa-brands fa-instagram]';
      github = 'btn-primary [override-button-fa-brands fa-github]';
      user = 'btn-info [override-button-fa-solid fa-user]';
      execute = 'btn-warning [override-button-fa-solid fa-bolt]';
      calc = 'btn-primary [override-button-fa-solid fa-calculator]';
      addressbook = 'btn-primary [override-button-fa-solid fa-address-book]';
      folderopen = 'btn-primary [override-button-fa-solid fa-folder-open]';
      folderclosed = 'btn-primary [override-button-fa-solid fa-folder]';
      moneybill = 'btn-primary [override-button-fa-solid fa-money-bill]';
      barcode = 'btn-primary [override-button-fa-solid fa-barcode]';
      qrcode = 'btn-primary [override-button-fa-solid fa-qrcode]';
      circleuser = 'btn-info [override-button-fa-solid fa-circle-user]';
      bell = 'btn-info [override-button-fa-solid fa-bell]';
      calendar = 'btn-primary [override-button-fa-solid fa-calendar-days]';
      checkmark = 'btn-success [override-button-fa-solid fa-check]';
      receipt = 'btn-warning [override-button-fa-solid fa-receipt]';
      invoice = 'btn-info [override-button-fa-solid fa-file-invoice-dollar]';
      filePDF = 'btn-primary [override-button-fa-regular fa-file-pdf]';
      fileCSV = 'btn-success [override-button-fa-solid fa-file-csv]';
      list = 'btn-info [override-button-fa-regular fa-rectangle-list]';
      camera = 'btn-primary [override-button-fa-solid fa-camera]';
      camerarotate = 'btn-primary [override-button-fa-solid fa-camera-rotate]';
      video = 'btn-primary [override-button-fa-solid fa-video]';
      videoNo = 'btn-secondary [override-button-fa-solid fa-video-slash]';
      videofile = 'btn-info [override-button-fa-solid fa-file-video]';
      imagefile = 'btn-info [override-button-fa-solid fa-file-image]';
      image = 'btn-primary [override-button-fa-solid fa-image]';
      film = 'btn-primary [override-button-fa-solid fa-film]';
      &record = 'btn-primary [override-button-fa-solid fa-record-vinyl]';
      microphone = 'btn-primary [override-button-fa-solid fa-microphone]';
      microphoneNo = 'btn-secondary [override-button-fa-solid fa-microphone]';
      noAudio = 'btn-secondary [override-button-fa-solid fa-microphone-slash]';
      userSecurity = 'btn-secondary [override-button-fa-solid fa-user-lock]';
      lock = 'btn-secondary [override-button-fa-solid fa-lock]';
      lockOpen = 'btn-secondary [override-button-fa-solid fa-lock-open]';

      function Iconbutton(Icon: string): string;
    end;
 {$ENDREGION}


 {$REGION 'Text'}
 TCSSClassText = class
  strict private
   type
    TCSSFontSize = class
     const
      fs1 = 'fs-1';
      fs2 = 'fs-2';
      fs3 = 'fs-3';
      fs4 = 'fs-4';
      fs5 = 'fs-5';
      fs6 = 'fs-6';
    end;

   type
    TCSSFontStyle = class
     const
      normal = 'fw-normal';
      bold = 'fw-bold';
      italic = 'fst-italic';
      light = 'fw-light';
      underline = 'text-decoration-underline';
      strikeout = 'text-decoration-line-through';
      monospace = 'font-monospace';
    end;

   type
    TCSSCapitalization = class
     const
      normal = 'text-capitalize';
      upper = 'text-uppercase';
      lower = 'text-lowercase';
    end;

   type
    TCSSTextAlign = class
     const
      left = 'text-start';
      center = 'text-center';
      right = 'text-end';
    end;

   type
    TCSSTextColor = class
     const
      primary = 'text-primary';
      secondary = 'text-secondary';
      success = 'text-success';
      danger = 'text-danger';
      warning = 'text-warning';
      info = 'text-info';
      ligth = 'text-light';
      dark = 'text-dark';
      muted = 'text-muted';
      white = 'text-white';
    end;
  private

  public

  class var
   Size: TCSSFontSize;
   Style: TCSSFontStyle;
   Capitalization: TCSSCapitalization;
   Align: TCSSTextAlign;
   Color: TCSSTextColor;
 end;
 {$ENDREGION}

 {$REGION 'Space'}
 TCSSClassSpace = class
  const
   SpaceMin_top_bottom = 'spacemin-y';
   spacemode = 'd2bridgespacemode';
   nospacemode = 'nod2bridgespacemode';
   margim_auto = 'm-auto';
   margim_left_right_auto = 'mx-auto';
   margim_top_bottom_auto = 'my-auto';
   margim0 = 'm-0';
   margim1 = 'm-1';
   margim2 = 'm-2';
   margim3 = 'm-3';
   margim4 = 'm-4';
   margim5 = 'm-5';
   margim_left0 = 'ml-0';
   margim_left1 = 'ml-1';
   margim_left2 = 'ml-2';
   margim_left3 = 'ml-3';
   margim_left4 = 'ml-4';
   margim_left5 = 'ml-5';
   margim_right0 = 'mr-0';
   margim_right1 = 'mr-1';
   margim_right2 = 'mr-2';
   margim_right3 = 'mr-3';
   margim_right4 = 'mr-4';
   margim_right5 = 'mr-5';
   margim_top0 = 'mt-0';
   margim_top1 = 'mt-1';
   margim_top2 = 'mt-2';
   margim_top3 = 'mt-3';
   margim_top4 = 'mt-4';
   margim_top5 = 'mt-5';
   margim_bottom0 = 'mb-0';
   margim_bottom1 = 'mb-1';
   margim_bottom2 = 'mb-2';
   margim_bottom3 = 'mb-3';
   margim_bottom4 = 'mb-4';
   margim_bottom5 = 'mb-5';
   margim_left_right_0 = 'mx-0';
   margim_left_right_1 = 'mx-1';
   margim_left_right_2 = 'mx-2';
   margim_left_right_3 = 'mx-3';
   margim_left_right_4 = 'mx-4';
   margim_left_right_5 = 'mx-5';
   margim_top_bottom_0 = 'my-0';
   margim_top_bottom_1 = 'my-1';
   margim_top_bottom_2 = 'my-2';
   margim_top_bottom_3 = 'my-3';
   margim_top_bottom_4 = 'my-4';
   margim_top_bottom_5 = 'my-5';
   padding_auto = 'p-auto';
   padding_left_right_auto = 'px-auto';
   padding_top_bottom_auto = 'py-auto';
   padding0 = 'p-0';
   padding1 = 'p-1';
   padding2 = 'p-2';
   padding3 = 'p-3';
   padding4 = 'p-4';
   padding5 = 'p-5';
   padding_left0 = 'pl-0';
   padding_left1 = 'pl-1';
   padding_left2 = 'pl-2';
   padding_left3 = 'pl-3';
   padding_left4 = 'pl-4';
   padding_left5 = 'pl-5';
   padding_right0 = 'pr-0';
   padding_right1 = 'pr-1';
   padding_right2 = 'pr-2';
   padding_right3 = 'pr-3';
   padding_right4 = 'pr-4';
   padding_right5 = 'pr-5';
   padding_top0 = 'pt-0';
   padding_top1 = 'pt-1';
   padding_top2 = 'pt-2';
   padding_top3 = 'pt-3';
   padding_top4 = 'pt-4';
   padding_top5 = 'pt-5';
   padding_bottom0 = 'pb-0';
   padding_bottom1 = 'pb-1';
   padding_bottom2 = 'pb-2';
   padding_bottom3 = 'pb-3';
   padding_bottom4 = 'pb-4';
   padding_bottom5 = 'pb-5';
   padding_left_right_0 = 'px-0';
   padding_left_right_1 = 'px-1';
   padding_left_right_2 = 'px-2';
   padding_left_right_3 = 'px-3';
   padding_left_right_4 = 'px-4';
   padding_left_right_5 = 'px-5';
   padding_top_bottom_0 = 'py-0';
   padding_top_bottom_1 = 'py-1';
   padding_top_bottom_2 = 'py-2';
   padding_top_bottom_3 = 'py-3';
   padding_top_bottom_4 = 'py-4';
   padding_top_bottom_5 = 'py-5';
   gutter0 = 'g-0';
   gutter1 = 'g-1';
   gutter2 = 'g-2';
   gutter3 = 'g-3';
   gutter4 = 'g-4';
   gutter5 = 'g-5';
   gutter_left0 = 'gl-0';
   gutter_left1 = 'gl-1';
   gutter_left2 = 'gl-2';
   gutter_left3 = 'gl-3';
   gutter_left4 = 'gl-4';
   gutter_left5 = 'gl-5';
   gutter_right0 = 'gr-0';
   gutter_right1 = 'gr-1';
   gutter_right2 = 'gr-2';
   gutter_right3 = 'gr-3';
   gutter_right4 = 'gr-4';
   gutter_right5 = 'gr-5';
   gutter_top0 = 'gt-0';
   gutter_top1 = 'gt-1';
   gutter_top2 = 'gt-2';
   gutter_top3 = 'gt-3';
   gutter_top4 = 'gt-4';
   gutter_top5 = 'gt-5';
   gutter_bottom0 = 'gb-0';
   gutter_bottom1 = 'gb-1';
   gutter_bottom2 = 'gb-2';
   gutter_bottom3 = 'gb-3';
   gutter_bottom4 = 'gb-4';
   gutter_bottom5 = 'gb-5';
   gutter_left_right_0 = 'gx-0';
   gutter_left_right_1 = 'gx-1';
   gutter_left_right_2 = 'gx-2';
   gutter_left_right_3 = 'gx-3';
   gutter_left_right_4 = 'gx-4';
   gutter_left_right_5 = 'gx-5';
   gutter_top_bottom_0 = 'gy-0';
   gutter_top_bottom_1 = 'gy-1';
   gutter_top_bottom_2 = 'gy-2';
   gutter_top_bottom_3 = 'gy-3';
   gutter_top_bottom_4 = 'gy-4';
   gutter_top_bottom_5 = 'gy-5';
 end;
 {$ENDREGION}



 var
  Col: TCSSClassCol;
  TabsColor: TCSSClassTabsColor;
  Color: TCSSClassColor;
  ColorName: TCSSClassColorName;
  Button: TCSSClassButton;
  DivHtml: TCSSClassDIV;
  Card: TCSSClassCard;
  CardGrid: TCSSClassCardGrid;
  PanelColor: TCSSClassPanelColor;
  Space: TCSSClassSpace;


implementation

uses
  SysUtils;

{ TCSSClass.TCSSClassButton }


{ TCSSClassButton }

function TCSSClassButton.iconbutton(Icon: string): string;
begin
 result:= ' [override-button-'+Icon+']';
end;

{ TCSSClass }

constructor TCSSClass.Create;
begin
 inherited;

 Col:= TCSSClassCol.Create;
 Card:= TCSSClassCard.Create;
 Image:= TCSSClassImage.Create;
 TabsColor:= TCSSClassTabsColor.Create;
 Color:= TCSSClassColor.Create;
 ColorName:= TCSSClassColorName.Create;
 Button:= TCSSClassButton.Create;
 DivHtml:= TCSSClassDIV.Create;
 PanelColor:= TCSSClassPanelColor.Create;
 Popup:= TCSSClassPopup.Create;
 Text:= TCSSClassText.Create;
 Font:= TCSSFontAwesome.Create;
 Space:= TCSSClassSpace.Create;

end;

destructor TCSSClass.Destroy;
begin
 FreeAndNil(Col);
 FreeAndNil(Card);
 FreeAndNil(Image);
 FreeAndNil(TabsColor);
 FreeAndNil(Color);
 FreeAndNil(ColorName);
 FreeAndNil(Button);
 FreeAndNil(DivHtml);
 FreeAndNil(PanelColor);
 FreeAndNil(Popup);
 FreeAndNil(Text);
 FreeAndNil(Font);
 FreeAndNil(Space);

 inherited;
end;

end.
