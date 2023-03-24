export type AppMetricaConfig = {
  apiKey: string;
  appVersion?: string;
  crashReporting?: boolean;
  firstActivationAsUpdate?: boolean;
  location: Location;
  locationTracking?: boolean;
  logs?: boolean;
  sessionTimeout?: number;
  statisticsSending?: boolean;
  preloadInfo?: PreloadInfo;
  // Only Android
  installedAppCollecting?: boolean;
  maxReportsInDatabaseCount?: number;
  nativeCrashReporting?: boolean;
  // Only iOS
  activationAsSessionStart?: boolean;
  sessionsAutoTracking?: boolean;
};

type FloorType = "male" | "female";

type UserProfileConfig = {
  name: string;
  floor?: FloorType;
  age: number;
  isNotification: boolean;
};

type PreloadInfo = {
  trackingId: string;
  additionalInfo?: Object;
};

type Location = {
  latitude: number;
  longitude: number;
  altitude?: number;
  accuracy?: number;
  course?: number;
  speed?: number;
  timestamp?: number;
};

type AppMetricaDeviceIdReason = "UNKNOWN" | "NETWORK" | "INVALID_RESPONSE";

type Screen = {
  screenName: string;
  searchQuery?: string;
};

type ProductCard = {
  name: string;
  sku: string;
  currency: "RUB" | "USD" | "EUR";
  price: string;
  quantity: string;
  categoriesPath?: Array<string>;
  payload?: Object;
};

type EcommerceShowScreenParams = Screen;

type EcommerceShowProductCardParams = Screen & ProductCard;

type EcommerceCartParams = Screen & ProductCard;

declare module "react-native-appmetrica-next" {
  const activate: (params: AppMetricaConfig) => void;
  const initPush: (token?: string) => void;
  const getToken: () => string;
  const reportUserProfile: (config: UserProfileConfig) => void;
  const pauseSession: () => void;
  const reportAppOpen: (deeplink?: string) => void;
  const reportError: (error: string, reason: Object) => void;
  const reportEvent: (eventName: string, attributes?: Object) => void;
  const reportReferralUrl: (referralUrl: string) => void;
  const requestAppMetricaDeviceID: (
    listener: (deviceId?: string, reason?: AppMetricaDeviceIdReason) => void
  ) => void;
  const resumeSession: () => void;
  const sendEventsBuffer: () => void;
  const setLocation: (location?: Location) => void;
  const setLocationTracking: (enabled: boolean) => void;
  const setStatisticsSending: (enabled: boolean) => void;
  const setUserProfileID: (userProfileID?: string) => void;
  const requestDeferredDeeplink: (
    listener: (deeplink?: string, reason?: string) => void
  ) => void;

  const showScreen: (params: EcommerceShowScreenParams) => void;
  const showProductCard: (params: EcommerceShowProductCardParams) => void;
  const addToCart: (params: EcommerceCartParams) => void;
  const removeFromCart: (params: EcommerceCartParams) => void;
  const beginCheckout: (
    products: Array<EcommerceCartParams>,
    identifier: string
  ) => void;
  const finishCheckout: (
    products: Array<EcommerceCartParams>,
    identifier: string
  ) => void;
}
