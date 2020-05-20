Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421971DC25B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 00:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728507AbgETWv6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 18:51:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgETWv6 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 18:51:58 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B404B20708;
        Wed, 20 May 2020 22:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590015117;
        bh=6M3UYo+lP4Q5z8KTNc19X5qmKIkadqyM78V5Jg8RXbk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NPehf3XhcpNB7X6B3CiBoI7ZapLjg/nHI9yc9SOZCLTPYGTvrUEX3TRqF5urCONVK
         USocpsRQnusCnpqILdPycSQVoAycXT6zYTzN7NkzClff5GwImZ0Lw5+pzY5doXvIPQ
         aMff7m8l+ehp2CY09IEyUY+NBdO5ULxIlnq8KQEw=
Date:   Wed, 20 May 2020 15:51:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 0/3] fscrypt: misc cleanups
Message-ID: <20200520225156.GA19246@sol.localdomain>
References: <20200511191358.53096-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511191358.53096-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 11, 2020 at 12:13:55PM -0700, Eric Biggers wrote:
> In fs/crypto/ and fscrypt.h, fix all kerneldoc warnings, and fix some
> coding style inconsistencies in function declarations.
> 
> Eric Biggers (3):
>   fscrypt: fix all kerneldoc warnings
>   fscrypt: name all function parameters
>   fscrypt: remove unnecessary extern keywords
> 
>  fs/crypto/crypto.c          |   9 +-
>  fs/crypto/fname.c           |  52 +++++++++---
>  fs/crypto/fscrypt_private.h |  88 +++++++++----------
>  fs/crypto/hooks.c           |   4 +-
>  fs/crypto/keysetup.c        |   9 +-
>  fs/crypto/policy.c          |  19 ++++-
>  include/linux/fscrypt.h     | 165 ++++++++++++++++++------------------
>  7 files changed, 193 insertions(+), 153 deletions(-)
> 

All applied to fscrypt.git#master for 5.8.

- Eric
