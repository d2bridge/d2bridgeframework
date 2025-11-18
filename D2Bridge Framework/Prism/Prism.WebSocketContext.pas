{
 +--------------------------------------------------------------------------+
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

unit Prism.WebSocketContext;

interface

uses
  Classes, SysUtils,
  Prism.Interfaces, Prism.Session;

type
  TPrismWebSocketContext = class
   strict private
   public
    Established: boolean;
    Reloading: boolean;
    Token: String;
    ChannelName: string;
    PrismSessionUUID: string;
    PrismSession: TPrismSession;
    FormUUID: string;
    constructor Create;
  end;


implementation

{ TPrismWebSocketContext }

constructor TPrismWebSocketContext.Create;
begin
 Established:= false;
 Reloading:= false;
end;

end.