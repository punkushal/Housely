import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housely/core/constants/app_limits.dart';
import 'package:housely/core/utils/file_utils.dart';
import 'package:housely/features/review/domain/entity/review.dart';
import 'package:housely/features/review/domain/usecases/add_review_use_case.dart';
import 'package:housely/features/review/domain/usecases/delete_review_image_use_case.dart';
import 'package:housely/features/review/domain/usecases/delete_review_use_case.dart';
import 'package:housely/features/review/domain/usecases/get_all_reviews_use_case.dart';
import 'package:housely/features/review/domain/usecases/update_review_use_case.dart';
import 'package:housely/features/review/domain/usecases/upload_reveiw_images_use_case.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final UploadReveiwImagesUseCase uploadReveiwImagesUseCase;
  final AddReviewUseCase addReviewUseCase;
  final GetAllReviewsUseCase getAllReviewsUseCase;
  final UpdateReviewUseCase updateReviewUseCase;
  final DeleteReviewImageUseCase deleteReviewImageUseCase;
  final DeleteReviewUseCase deleteReviewUseCase;
  ReviewBloc({
    required this.uploadReveiwImagesUseCase,
    required this.addReviewUseCase,
    required this.getAllReviewsUseCase,
    required this.updateReviewUseCase,
    required this.deleteReviewImageUseCase,
    required this.deleteReviewUseCase,
  }) : super(ReviewState()) {
    on<AddReview>(_onAddReview);
    on<AddReviewImages>(_onAddReviewImages);
    on<RemoveReviewImage>(_removeReviewImage);
    on<AddRatings>(_addRatings);
    on<GetAllReviews>(_onGetAllReviews);
    on<UpdateReview>(_onUpdateReview);
    on<RemoveNetworkReviewImage>(_removeNetowrkImage);
    on<SetInitialValues>(_setInitialValues);
    on<DeleteReview>(_onDeleteReview);
  }

  void _setInitialValues(SetInitialValues event, Emitter<ReviewState> emit) {
    final int? index = event.ratings > 0 ? event.ratings - 1 : null;
    emit(
      state.copyWith(
        ratings: index,
        existingNetworkImages: event.existingNetworkImages,
      ),
    );
  }

  void _onAddReviewImages(AddReviewImages event, Emitter<ReviewState> emit) {
    final currentImages = List<File>.from(state.localImages);

    double currentSize = FileUtils.getTotalSizeInMB(currentImages);

    final allowedImages = <File>[];

    for (var image in event.reviewImages) {
      final imageSize = FileUtils.getFileSizeInMB(image);
      if (currentSize + imageSize <= maxReviewImagesSizeInMB) {
        allowedImages.add(image);
        currentSize += imageSize;
      } else {
        break;
      }
    }

    if (allowedImages.isEmpty) {
      return emit(
        state.copyWith(
          imageError: "Image files exceed $maxReviewImagesSizeInMB MB",
        ),
      );
    }

    emit(
      state.copyWith(
        localImages: [...state.localImages, ...allowedImages],
        imageError: null,
      ),
    );
  }

  void _removeReviewImage(RemoveReviewImage event, Emitter<ReviewState> emit) {
    final updatedImages = List<File>.from(state.localImages)
      ..removeAt(event.index);
    emit(state.copyWith(localImages: updatedImages, imageError: null));
  }

  void _removeNetowrkImage(
    RemoveNetworkReviewImage event,
    Emitter<ReviewState> emit,
  ) {
    final updatedList = List<Map<String, dynamic>>.from(
      state.existingNetworkImages,
    )..removeAt(event.index);
    emit(state.copyWith(existingNetworkImages: updatedList));
  }

  void _addRatings(AddRatings event, Emitter<ReviewState> emit) {
    if (event.ratings < 0) {
      emit(state.copyWith(ratings: null));
    } else {
      emit(state.copyWith(ratings: event.ratings));
    }
  }

  // upload review images
  Future<Map<String, dynamic>?> _uploadReviewImages({
    required String userEmail,
    required List<File> reviewImages,
  }) async {
    final param = UploadReviewImagesParams(
      userEmail: userEmail,
      images: reviewImages,
    );
    final result = await uploadReveiwImagesUseCase(param);

    return result.fold(
      (f) {
        return null;
      },
      (imageUrl) {
        return imageUrl;
      },
    );
  }

  // delete review image
  Future<String?> _deleteReviewImage({required String fileId}) async {
    final result = await deleteReviewImageUseCase(
      DeleteReviewImageParam(fileId: fileId),
    );

    result.fold((f) => f.message, (_) => null);
    return null;
  }

  // add review
  Future<void> _onAddReview(AddReview event, Emitter<ReviewState> emit) async {
    emit(state.copyWith(status: .loading));

    bool hasLocalImages = state.localImages.isNotEmpty;
    Map<String, dynamic>? reviewImagesUrl;
    if (hasLocalImages) {
      reviewImagesUrl = await _uploadReviewImages(
        userEmail: event.review.userName,
        reviewImages: state.localImages,
      );

      if (reviewImagesUrl == null) {
        return emit(
          state.copyWith(
            status: .initial,
            errorMessage: "Failed to upload review images",
          ),
        );
      }
    }

    final result = await addReviewUseCase(
      AddReviewParams(
        propertyId: event.propertyId,
        review: event.review.copyWith(reviewImages: reviewImagesUrl),
      ),
    );

    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message, status: .error)),
      (_) => emit(state.copyWith(status: .success)),
    );
  }

  // fetch all reviews
  Future<void> _onGetAllReviews(
    GetAllReviews event,
    Emitter<ReviewState> emit,
  ) async {
    final result = await getAllReviewsUseCase(
      GetAllReviewsParams(propertyId: event.propertyId, lastDoc: event.lastDoc),
    );

    result.fold(
      (f) => emit(state.copyWith(errorMessage: f.message, status: .error)),
      (data) {
        emit(
          state.copyWith(
            allReviews: data.reviews,
            lastDoc: data.lastDoc,
            status: .loaded,
          ),
        );
      },
    );
  }

  // add review
  Future<void> _onUpdateReview(
    UpdateReview event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: .loading));
    final hasExistedReviewImages = event.updatedReview.reviewImages != null;

    if (hasExistedReviewImages) {
      final remainingIds = (event.updatedReview.reviewImages!['images'] as List)
          .map((img) => img['id'])
          .toSet();

      for (var original in state.existingNetworkImages) {
        if (!remainingIds.contains(original['id'])) {
          await deleteReviewImageUseCase(
            DeleteReviewImageParam(fileId: original['id']),
          );
        }
      }

      // upload new review images (if picked) and merge them
      List<dynamic> combinedImages = List.from(
        event.updatedReview.reviewImages!['images'],
      );

      if (state.localImages.isNotEmpty) {
        final newUploads = await _uploadReviewImages(
          userEmail: event.updatedReview.userName,
          reviewImages: state.localImages,
        );

        if (newUploads != null && newUploads['images'] != null) {
          combinedImages.addAll(newUploads['images']);
        }
      }

      final updatedReview = event.updatedReview.copyWith(
        reviewImages: {'images': combinedImages},
      );

      final result = await updateReviewUseCase(
        UpdateReviewParams(
          propertyId: event.propertyId,
          review: updatedReview,
          oldRating: event.oldRating,
        ),
      );

      result.fold(
        (f) => emit(state.copyWith(status: .error, errorMessage: f.message)),
        (_) => emit(state.copyWith(status: .success)),
      );
    } else {
      final result = await updateReviewUseCase(
        UpdateReviewParams(
          propertyId: event.propertyId,
          review: event.updatedReview,
          oldRating: event.oldRating,
        ),
      );

      result.fold(
        (f) => emit(state.copyWith(status: .error, errorMessage: f.message)),
        (_) => emit(state.copyWith(status: .success)),
      );
    }
  }

  // delete review
  Future<void> _onDeleteReview(
    DeleteReview event,
    Emitter<ReviewState> emit,
  ) async {
    emit(state.copyWith(status: .loading));

    try {
      final List<String> fileIdsToDelete = [];
      final hasReviewImages = event.review.reviewImages != null;
      if (hasReviewImages) {
        final images = event.review.reviewImages!['images'] as List<dynamic>;
        for (var image in images) {
          if (image is Map && image.containsKey('id')) {
            fileIdsToDelete.add(image['id'].toString());
          }
        }
      }

      if (fileIdsToDelete.isNotEmpty) {
        await Future.wait(
          fileIdsToDelete.map((id) {
            return _deleteReviewImage(fileId: id);
          }),
        );
      }

      final result = await deleteReviewUseCase(
        DeleteReviewParams(
          reviewId: event.review.reviewId,
          propertyId: event.propertyId,
          ratingToDelete: event.ratingToDelete,
        ),
      );

      result.fold(
        (f) => emit(state.copyWith(errorMessage: f.message, status: .error)),
        (_) {
          emit(state.copyWith(status: .deleted, ratings: null));
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          errorMessage: "Failed to delete review images: $e",
          status: .error,
        ),
      );
    }
  }
}
