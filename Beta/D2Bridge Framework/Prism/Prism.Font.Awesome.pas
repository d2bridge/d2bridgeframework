{ +--------------------------------------------------------------------------+
  D2Bridge Framework Content

  Author: Talis Jonatas Gomes
  Email: talisjonatas@me.com

  This source code is distributed under the terms of the
  GNU Lesser General Public License (LGPL) version 2.1.

  This library is free software; you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License as published by
  the Free Software Foundation; either version 2.1 of the License, or
  (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
  GNU Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public License
  along with this library; if not, see <https://www.gnu.org/licenses/>.

  If you use this software in a product, an acknowledgment in the product
  documentation would be appreciated but is not required.

  God bless you
 +--------------------------------------------------------------------------+
}

{$I ..\D2Bridge.inc}

unit Prism.Font.Awesome;

interface

uses
  Classes;

type
 TCSSFontAwesome = class
  const
    add = 'fa-solid fa-plus';
    addressbook = 'fa-solid fa-address-book';
    alarmclock = 'fa-solid fa-alarm-clock';
    arrowdown = 'fa-solid fa-arrow-down';
    arrowleft = 'fa-solid fa-arrow-left';
    arrowright = 'fa-solid fa-arrow-right';
    arrowup = 'fa-solid fa-arrow-up';
    barcode = 'fa-solid fa-barcode';
    basketshopping = 'fa-solid fa-basket-shopping';
    bell = 'fa-solid fa-bell';
    bellslash = 'fa-solid fa-bell-slash';
    bluetoothBrand = 'fa-brands fa-bluetooth';
    bluetoothSolid = 'fa-brands fa-bluetooth';
    bolt = 'fa-solid fa-bolt';
    book = 'fa-solid fa-book';
    bookBookmark = 'fa-solid fa-book-bookmark';
    bookOpen = 'fa-solid fa-book-open';
    bottleDroplet = 'fa-solid fa-bottle-droplet';
    bottleWater = 'fa-solid fa-bottle-water';
    bowlFood = 'fa-solid fa-bowl-food';
    bowlRice = 'fa-solid fa-bowl-rice';
    box = 'fa-solid fa-box';
    boxArchive = 'fa-solid fa-box-archive';
    boxesPacking = 'fa-solid fa-boxes-packing';
    boxOpen = 'fa-solid fa-box-open';
    brazilianRealSign = 'fa-solid fa-brazilian-real-sign';
    breadSlice = 'fa-solid fa-bread-slice';
    briefcase = 'fa-solid fa-briefcase';
    broom = 'fa-solid fa-broom';
    building = 'fa-solid fa-building';
    bullhorn = 'fa-solid fa-bullhorn';
    bus = 'fa-solid fa-bus';
    calc = 'fa-solid fa-calculator';
    calculator = 'fa-solid fa-calculator';
    calendar = 'fa-solid fa-calendar-days';
    calendarDays = 'fa-solid fa-calendar-days';
    cancel = 'fa-solid fa-xmark';
    car = 'fa-solid fa-car';
    caron = 'fa-solid fa-car-on';
    carSide = 'fa-solid fa-car-side';
    cartArrowDown = 'fa-solid fa-cart-arrow-down';
    cartPlus = 'fa-solid fa-cart-plus';
    cartShopping = 'fa-solid fa-cart-shopping';
    check = 'fa-solid fa-check';
    circleexclamation = 'fa-solid fa-circle-exclamation';
    circleuser = 'fa-solid fa-circle-user';
    close = 'fa-solid fa-right-from-bracket';
    comment = 'fa-solid fa-comment';
    comments = 'fa-solid fa-comments';
    config = 'fa-solid fa-screwdriver-wrench';
    copy = 'fa-solid fa-copy';
    cut = 'fa-solid fa-scissors';
    decrease = 'fa-solid fa-minus';
    delete = 'fa-solid fa-trash';
    desktop = 'fa-solid fa-desktop';
    doorClosed = 'fa-solid fa-door-closed';
    doorOpen = 'fa-solid fa-door-open';
    download = 'fa-solid fa-cloud-arrow-down';
    edit = 'fa-solid fa-pen-to-square';
    ellipsis = 'fa-solid fa-ellipsis';
    ellipsisVertical = 'fa-solid fa-ellipsis-vertical';
    envelopeCircleCheck = 'fa-solid fa-envelope-circle-check';
    envelopeOpenRegular = 'fa-regular fa-envelope-open';
    envelopeOpenSolid = 'fa-solid fa-envelope-open';
    envelopeRegular = 'fa-regular fa-envelope';
    envelopeSolid = 'fa-solid fa-envelope';
    eraser = 'fa-solid fa-eraser';
    exclamation = 'fa-solid fa-exclamation';
    execute = 'fa-solid fa-bolt';
    fileCSV = 'fa-solid fa-file-csv';
    filePDF = 'fa-regular fa-file-pdf';
    flag = 'fa-solid fa-flag';
    folderclosed = 'fa-solid fa-folder';
    folderopen = 'fa-solid fa-folder-open';
    handHolding = 'fa-solid fa-hand-holding';
    handHoldingDollar = 'fa-solid fa-hand-holding-dollar';
    image = 'fa-solid fa-image';
    invoice = 'fa-solid fa-file-invoice-dollar';
    key = 'fa-solid fa-key';
    list = 'fa-regular fa-rectangle-list';
    listCheck = 'fa-solid fa-list-check';
    listOl = 'fa-solid fa-list-ol';
    listUl = 'fa-solid fa-list-ul';
    lock = 'fa-solid fa-lock';
    lockOpen = 'fa-solid fa-lock-open';
    magnifyingGlass = 'fa-solid fa-magnifying-glass';
    menu = 'fa-solid fa-bars';
    money = 'fa-solid fa-money-bill';
    numbereight = 'fa-solid fa-8';
    numberfive = 'fa-solid fa-5';
    numberfour = 'fa-solid fa-4';
    numbernine = 'fa-solid fa-9';
    numberone = 'fa-solid fa-1';
    numberseven = 'fa-solid fa-7';
    numbersix = 'fa-solid fa-6';
    numberthree = 'fa-solid fa-3';
    numbertwo = 'fa-solid fa-2';
    numberzero = 'fa-solid fa-0';
    open = 'fa-solid fa-up-right-from-square';
    options = 'fa-solid fa-sliders';
    person = 'fa-solid fa-person';
    personCircleCheck = 'fa-solid fa-person-circle-check';
    personCircleExclamation = 'fa-solid fa-person-circle-exclamation';
    personCircleMinus = 'fa-solid fa-person-circle-minus';
    personCirclePlus = 'fa-solid fa-person-circle-plus';
    personCircleQuestion = 'fa-solid fa-person-circle-question';
    personCircleXmark = 'fa-solid fa-person-circle-xmark';
    power = 'fa-solid fa-power-off';
    print = 'fa-solid fa-print';
    question = 'fa-solid fa-question';
    receipt = 'fa-solid fa-receipt';
    refresh = 'fa-solid fa-arrows-rotate';
    save = 'fa-solid fa-floppy-disk';
    search = 'fa-solid fa-magnifying-glass';
    select = 'fa-solid fa-square-check';
    share = 'fa-solid fa-share';
    squareenvelope = 'fa-solid fa-square-envelope';
    towerbroadcast = 'fa-solid fa-tower-broadcast';
    triangleexclmation = 'fa-solid fa-triangle-exclamation';
    upload = 'fa-solid fa-upload';
    user = 'fa-solid fa-user';
    vanShuttle = 'fa-solid fa-van-shuttle';
    view = 'fa-solid fa-eye';
    wallet = 'fa-solid fa-wallet';
 end;


implementation

end.
