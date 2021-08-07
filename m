Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EDF3E33BF
	for <lists+linux-fscrypt@lfdr.de>; Sat,  7 Aug 2021 08:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhHGGbJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 7 Aug 2021 02:31:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhHGGbI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 7 Aug 2021 02:31:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8596360EEA;
        Sat,  7 Aug 2021 06:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628317851;
        bh=gqBbm7RQvMmGiA3+sO0OFu5gS/QfanB2nByt2Gwpxgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FZIE/jRKv7kWLZA2wXSQwDq9hr6eB0pk/cWpEoy68ubzTdGleeflaGLAnR7YPhFKH
         fjQtBQpnH57rlyH4JfTw92i9rJFlpocxI9GSQCXA9Vn8cbuTlVI3ySZxs+CEa5SsHZ
         p6/415HlU/z8Kcz7SzW20AX8rNnWIWbPYW9qFMtS1czQu/dIKlFJ4KnhW/XOhMp9ZG
         M1z3QVHPSISdZAmyuYYuwedK+JGKGZyyGWWPrRT5lma/KI0UOi7iymhtrQE8a66d9f
         MH/Y4WCM3hPn4dMkOvPdWReMFiaBl9CqMcZg6eDLFKgNjTg6Wj8BXsz4VK4K67PenR
         Wsakcx87MBmCQ==
Date:   Fri, 6 Aug 2021 23:30:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH] fscrypt: document struct fscrypt_operations
Message-ID: <YQ4omeTN73JFZQY+@sol.localdomain>
References: <20210729043728.18480-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210729043728.18480-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 28, 2021 at 09:37:28PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Document all fields of struct fscrypt_operations so that it's more clear
> what filesystems that use (or plan to use) fs/crypto/ need to implement.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  include/linux/fscrypt.h | 109 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 105 insertions(+), 4 deletions(-)

Applied to fscrypt.git#master for 5.15.

- Eric
