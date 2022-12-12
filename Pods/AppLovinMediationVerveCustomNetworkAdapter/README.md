# AppLovinMediationVerveCustomNetworkAdapter
AppLovin MAX supports both bidding and waterfall mediation with Verve HyBid SDK.
Currently the following ad formats are supported:
* Banner
* MRect
* Fullscreen Interstitial (including video)
* Fullscreen Rewarded Video

Native ad format will be supported in a future release.

# Bidding
For bidding, please follow the official AppLovin documentation.
1. [AppLovin SDK Integration](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration#integration)
2. [Preparing Verve MAX mediation adapter](https://dash.applovin.com/documentation/mediation/ios/mediation-adapters?network=VERVE_NETWORK)
3. [Verve Integration Guide](https://dash.applovin.com/documentation/mediation/ios/mediation-setup/verve#verve-integration-guide)

The most recent SDK versions supported by AppLoving MAX bidding mediation are:
* AppLovin SDK: [11.4.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/releases)
* AppLovin Verve bidding adapter: [2.16.0.0](https://github.com/AppLovin/AppLovin-MAX-SDK-iOS/blob/master/Verve/CHANGELOG.md)
* Verve HyBid SDK: [2.16.0](https://github.com/pubnative/pubnative-hybid-ios-sdk/releases)

# Waterfall
Waterfall mediation is only supported via AppLovin MAX's custom network adapters.

## AppLovin SDK Integration
Please follow the official [AppLovin SDK Integration documentation](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration#integration). This step is identical to bidding setup.

We recommend that you also complete steps 2 and 3 for a complete AppLovin MAX SDK bidding setup. This will ensure that your app contains all components required to enable bidding in parallel to waterfall mediation without further app changes required.

## Custom Network Adapter Integration

Copy the customized CocoaPods script below to your Podfile:

```
# Sources
source 'https://github.com/CocoaPods/Specs.git'

# Settings
use_frameworks!
inhibit_all_warnings!
# Pods
target 'YOUR_PROJECT_NAME' do
    pod 'AppLovinSDK'
    pod 'AppLovinMediationVerveAdapter' # for Bidding
    pod 'AppLovinMediationVerveCustomNetworkAdapter' # for Waterfall
end
```

## Custom SDK Network Integration Guide for Waterfall Mediation
This page gives you step-by-step instructions to show you how you enable Verve HyBid SDK as an ad network.

These instructions are based on [Custom SDK Network Integration Guide](https://dash.applovin.com/documentation/mediation/ios/mediation-setup/custom-sdk) in AppLovin MAX documentation.

### Step 1. Add Custom SDK Network Settings
In the MAX Dashboard, select [MAX > Mediation > Manage > Networks](https://dash.applovin.com/o/mediation/networks/). Then click **Click here to add a Custom Network** at the bottom of the page. The Create Custom Network page appears. Add the information about Verve SDK custom network:
* *Network Type:* choose *SDK*.
* *Name:* *Verve HyBid SDK Waterfall Mediation*
* *iOS Adapter Class Name:* `AppLovinMediationVerveCustomNetworkAdapter`
* *Android / Fire OS Adapter Class Name:* `net.pubnative.adapters.applovin.AppLovinMediationVerveCustomNetworkAdapter`

**Please note:** iOS and Android Class Names must be entered _exactly_ as indicated above.

![Custom SDK Network Settings](https://github.com/pubnative/pubnative-hybid-android-sdk/wiki/Images/applovin-custom-sdk-network-settings.png)

Press Save to create the SDK network.
This concludes the initial SDK setup. no further changes will be required to your mobile app.
Please continue with the following steps to setup or change any ad units.

## Ad Unit Setup for Verve SDK Waterfall Mediation
This page gives you step-by-step instructions for how you set Verve live as an ad network on the MAX Mediation platform.

### Step 1: Obtain Application Token and Zone ID from PubNative Publisher Dashboard
* Login to your [PubNative Publisher Dashboard](https://dashboard.pubnative.net/)
* Create or locate AppToken and Zone ID for the Ad Unit you wish to configure

### Step 2: Enable Verve SDK network in your MAX Account

1. When you have the Verve AppToken and Zone ID values you need, log in to your MAX account and select [MAX > Manage > Ad Units](https://dash.applovin.com/o/mediation/ad_units/).
2. Click the MAX ad unit placement on which you want to enable Verve.
3. Locate section **Custom Networks & Deals** and unfold **Custom Network (SDK) - Verve HyBid SDK Waterfall Mediation**
* Enable the **Status** toggle switch
* For **Placement ID** enter your *Zone ID* value from PubNative Publisher Dashboard
* For **Custom Parameters** enter the following JSON String: `{"pn_app_token":"YOUR APPTOKEN FROM PUBNATIVE PUBLISHER DASHBOARD"}`
* For **CPM Price** consult your Verve Account Manager to choose the correct value.

*Please note:* Use your actual appToken from PubNative Publisher Dashboard instead of the placeholder text written above.

![Custom SDK Network AdUnit Setup](https://github.com/pubnative/pubnative-hybid-android-sdk/wiki/Images/applovin-custom-network-adunit.png)

Repeat these steps for each Ad Unit separately.
