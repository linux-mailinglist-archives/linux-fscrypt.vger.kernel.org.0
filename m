Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1A9B8E0C8
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 00:31:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfHNWbr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Aug 2019 18:31:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726166AbfHNWbr (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Aug 2019 18:31:47 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB7D2064A
        for <linux-fscrypt@vger.kernel.org>; Wed, 14 Aug 2019 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565821906;
        bh=aiXKc2rJsEpYm//CWfdIQi4VCzZOAWb7yVcqil4A1No=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=0AuZlmpNtFGQg3vAG302re0Bkt9fRGdIDPtbu89ac6fAWttElYYlu8pYA3Xadp13U
         Wno/0aOP6mkoE8yKMJ7wak9WS2Eai5QKyeOo2d0AOymuE8BMWYMbAK/LVao1WfxRYQ
         4+X/XkGPmzsBIXr5lzAOweAjNIzQx33hYbA+aTY0=
Date:   Wed, 14 Aug 2019 15:31:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/4] fscrypt: logging improvements, and use ENOPKG
Message-ID: <20190814223144.GD101319@gmail.com>
Mail-Followup-To: linux-fscrypt@vger.kernel.org
References: <20190724195422.42495-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724195422.42495-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 24, 2019 at 12:54:18PM -0700, Eric Biggers wrote:
> Patches 1-3 make some small improvements to warning and error messages
> in fs/crypto/, including logging all types of unsupported encryption
> contexts rather than just ones where the encryption modes are invalid.
> 
> Patch 4 changes the error code for "missing crypto API support" from
> ENOENT to ENOPKG, to avoid an ambiguity.  This is a logically separate
> change, but it's in this series to avoid conflicts.
> 
> Eric Biggers (4):
>   fscrypt: make fscrypt_msg() take inode instead of super_block
>   fscrypt: improve warning messages for unsupported encryption contexts
>   fscrypt: improve warnings for missing crypto API support
>   fscrypt: use ENOPKG when crypto API support missing
> 
>  fs/crypto/crypto.c          | 13 ++++----
>  fs/crypto/fname.c           |  8 ++---
>  fs/crypto/fscrypt_private.h | 10 +++---
>  fs/crypto/hooks.c           |  6 ++--
>  fs/crypto/keyinfo.c         | 61 +++++++++++++++++++++++++------------
>  5 files changed, 57 insertions(+), 41 deletions(-)
> 
> -- 
> 2.22.0.657.g960e92d24f-goog
> 

All applied to fscrypt tree for 5.4.

- Eric
