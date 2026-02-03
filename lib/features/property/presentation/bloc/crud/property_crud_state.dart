part of 'property_crud_bloc.dart';

/// Status enum to track the overall operation status
enum PropertyCrudStatus {
  initial,
  loading,
  success,
  error,
  networkPropertyLoaded,
}

/// Operation type to identify which operation just completed
enum PropertyOperation { none, create, update, delete }

class PropertyCrudState extends Equatable {
  // Overall status
  final PropertyCrudStatus status;
  final PropertyOperation lastOperation;
  final String? errorMessage;

  // Image management - LOCAL (picked by user, not yet uploaded)
  final File? localCoverImage;
  final List<File> localGalleryImages;

  // Image management - NETWORK (existing images from Appwrite)
  final String? networkCoverImageUrl;
  final List<String> networkGalleryImageUrls;
  final Map<String, String> networkUrlToIdMap;

  // Upload progress tracking
  final bool isUploadingCover;
  final bool isUploadingGallery;

  // Property data (for holding the original property when editing)
  final Property? originalProperty;

  // Property data (from firebase when updating)
  final Property? netWorkProperty;

  // Track which network images were removed (for deletion during update)
  final List<String> removedNetworkImageIds;

  const PropertyCrudState({
    this.status = PropertyCrudStatus.initial,
    this.lastOperation = PropertyOperation.none,
    this.errorMessage,
    this.localCoverImage,
    this.localGalleryImages = const [],
    this.networkCoverImageUrl,
    this.networkGalleryImageUrls = const [],
    this.networkUrlToIdMap = const {},
    this.isUploadingCover = false,
    this.isUploadingGallery = false,
    this.originalProperty,
    this.removedNetworkImageIds = const [],
    this.netWorkProperty,
  });

  @override
  List<Object?> get props => [
    status,
    lastOperation,
    errorMessage,
    localCoverImage,
    localGalleryImages,
    networkCoverImageUrl,
    networkGalleryImageUrls,
    isUploadingCover,
    isUploadingGallery,
    originalProperty,
    removedNetworkImageIds,
    networkUrlToIdMap,
    netWorkProperty,
  ];

  PropertyCrudState copyWith({
    PropertyCrudStatus? status,
    PropertyOperation? lastOperation,
    String? errorMessage,
    File? localCoverImage,
    List<File>? localGalleryImages,
    String? networkCoverImageUrl,
    List<String>? networkGalleryImageUrls,
    bool? isUploadingCover,
    bool? isUploadingGallery,
    Property? originalProperty,
    Property? netWorkProperty,
    List<String>? removedNetworkImageIds,
    final Map<String, String>? networkUrlToIdMap,
  }) {
    return PropertyCrudState(
      status: status ?? this.status,
      lastOperation: lastOperation ?? this.lastOperation,
      errorMessage: errorMessage,
      localCoverImage: localCoverImage ?? this.localCoverImage,
      localGalleryImages: localGalleryImages ?? this.localGalleryImages,
      networkCoverImageUrl: networkCoverImageUrl ?? this.networkCoverImageUrl,
      networkGalleryImageUrls:
          networkGalleryImageUrls ?? this.networkGalleryImageUrls,
      networkUrlToIdMap: networkUrlToIdMap ?? this.networkUrlToIdMap,
      isUploadingCover: isUploadingCover ?? this.isUploadingCover,
      isUploadingGallery: isUploadingGallery ?? this.isUploadingGallery,
      originalProperty: originalProperty ?? this.originalProperty,
      removedNetworkImageIds:
          removedNetworkImageIds ?? this.removedNetworkImageIds,
      netWorkProperty: netWorkProperty ?? this.netWorkProperty,
    );
  }

  /// Check if we have a cover image to display (either local or network)
  bool get hasCoverImage =>
      localCoverImage != null || networkCoverImageUrl != null;

  /// Get all gallery images (both local and network) for display
  List<dynamic> get allGalleryImages => [
    ...networkGalleryImageUrls,
    ...localGalleryImages,
  ];

  /// Check if any upload operation is in progress
  bool get isUploading => isUploadingCover || isUploadingGallery;

  /// Total count of gallery images
  int get galleryImageCount => allGalleryImages.length;
}
