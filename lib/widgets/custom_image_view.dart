import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

extension ImageTypeExtension on String {
  ImageType get imageType{
    if(this.startsWith('http') || this.startsWith('https')){
      return ImageType.web;
    }
    else if(this.endsWith('.svg')){
      return ImageType.svg;
    }
    else if(this.startsWith('file://') || this.startsWith('/') || this.contains(':/') || this.contains(':\\')){
      return ImageType.file;
    }
    else{
      return ImageType.png;
    }
  }
}

enum ImageType {svg, png, web, file, unknown}

class CustomImageView extends StatelessWidget {
  const CustomImageView(
    {this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.placeHolder = 'assets/images/img_profile.jpeg'});

  // [imagePath] is required parameter for showing image
  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final String placeHolder;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry?  margin;
  final BorderRadius? radius;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context){
    return alignment != null
      ? Align(alignment: alignment!, child: _buildWidget())
      : _buildWidget();
  }

  Widget _buildWidget(){
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: _buildCircleImage(),
      ),
    );
  }

  // Build the image with border radius 
  _buildCircleImage(){
    if(radius != null){
      return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: _buildImageWithBorder(),
      );
    }
    else{
      return _buildImageWithBorder();
    }
  }

  // Build the image with Border and border radius styel
  _buildImageWithBorder(){
    if(border != null){
      return Container(
        decoration: BoxDecoration(
          border: border,
          borderRadius: radius,
        ),
        child: _buildImageView(),
        );
    }
    else{
      return _buildImageView();
    }
  }

  Widget _buildImageView(){
    if(imagePath != null && imagePath!.isNotEmpty && imagePath != "null"){
      switch(imagePath!.imageType){
        case ImageType.svg:
          return Container(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              colorFilter: this.color != null
                ? ColorFilter.mode(
                    this.color ?? Colors.transparent, BlendMode.srcIn)
                : null,
            ),
          );
        case ImageType.file:
          return Image.file(
            File(imagePath!),
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
          );
        case ImageType.web:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
            color: color,
            placeholder: (context, url) => Container(
              height: 30,
              width: 30,
              child: LinearProgressIndicator(
                color: Colors.grey.shade200,
                backgroundColor: Colors.grey.shade100,
              ),
            ),
            errorWidget: (context, url, error) => _buildPlaceholderImage(),
          );
        case ImageType.png:
        default:
          if (imagePath!.endsWith('.svg')) {
            return Container(
              height: height,
              width: width,
              child: SvgPicture.asset(
                imagePath!,
                height: height,
                width: width,
                fit: fit ?? BoxFit.contain,
                colorFilter: this.color != null
                    ? ColorFilter.mode(
                        this.color ?? Colors.transparent, BlendMode.srcIn)
                    : null,
              ),
            );
          }
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
          );
      }
    }
    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    if (placeHolder.isEmpty) return SizedBox();
    
    switch (placeHolder.imageType) {
      case ImageType.svg:
        return Container(
          height: height,
          width: width,
          child: SvgPicture.asset(
            placeHolder,
            height: height,
            width: width,
            fit: fit ?? BoxFit.contain,
          ),
        );
      default:
        return Image.asset(
          placeHolder,
          height: height,
          width: width,
          fit: fit ?? BoxFit.cover,
        );
    }
  }
}