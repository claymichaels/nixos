{ config, pkgs, ... }:

{
	programs.firefox = {
		enable = true;
		policies = {
			# about:policies  / cannot be inside of profiles
			DisableTelemetry = true;
			DisableFirefoxStudies = true;
			EnableTrackingProtection = {
				value = true;
				locked = true;
				cryptomining = true;
				fingerprinting = true;
			};
			OfferToSaveLogins = false;
			#preferences.privacy.resistFingerprinting = true; #HM floorp.preferences 404
		}; # policies
		profiles.default = {
			id = 0;
			name = "default";
			isDefault = true;
			extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
				ublock-origin
				bitwarden
				gesturefy
			];
			settings = {
				extensions.autoDisablescopes = 0;
			};
			search = {
				default = "ddg";
				privateDefault = "ddg";
				force = true; # Stops Floorp from re-writing the dang config file
				order = [ "Nix Packages" "NixOS Wiki" ];
				engines = {
					nix-packages = {
						name = "Nix Packages";
						icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
						definedAliases = [ "!n" ];
						urls = [{
							template = "https://search.nixos.org/packages";
							params = [
								{ name = "type"; value = "packages"; }
								{ name = "query"; value = "{searchTerms}"; }
							];
						}];
					};
					nixos-wiki = {
						name = "NixOS Wiki";
						urls = [{ template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; }];
						iconMapObj."16" = "https://wiki.nixos.org/favicon.ico";
						definedAliases = [ "!nw" ];
					}; # nixos-wiki
				}; # engines
			}; # search
#			extensions.packages = with pkgs; [
#				ublock-origin
#				bitwarden
#				gesturefy
#			];
			#displayBookmarksToolbar = "newtab"; # 404
#			{
#				"ublock@raymondhill.net" = {
#					install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
#					installation_mode = "force_installed";
#				};
#				"{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
#					install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden/latest.xpi";
#					installation_mode = "force_installed";
#				};
#				"{506e023c-7f2b-40a3-8066-bc5deb40aebe}" = {
#					install_url = "https://addons.mozilla.org/firefox/downloads/file/4561845/gesturefy-3.2.15.xpi";
#					installation_mode = "force_installed";
#				};
#			}; # extensionSettings
		}; # profiles.<name>
	}; # programs.floorp
}
