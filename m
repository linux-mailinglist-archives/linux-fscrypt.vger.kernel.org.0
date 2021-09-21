Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CF4412D78
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Sep 2021 05:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237514AbhIUDcP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Sep 2021 23:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232102AbhIUDTL (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Sep 2021 23:19:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C10B560FA0;
        Tue, 21 Sep 2021 03:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632194263;
        bh=1z2WAjQcgYOvO1mOy7tZvGYG0cWDjea2L4QGJOBqXAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfAHRu31KG3TG0GFmYsYqIynz89ivQwawvig6FqG9mFfDKclwPC2tAqXg+XxwC510
         dKhH5VQdRP5cnl7yeHUPIgYKDkbLyXwADJ9kY7dOYreG8CkkiTStmaAY/0bNMnHkn6
         n5npjmo00AqREwTfwH9XqKpNRcuErmIxqdJxqfQ6UetUWz6wgbILr/UMu6pAAYQJrc
         zgoWhIY/wM6NKkoZbQutvcFtqjFBu9cu7WZta6glZmqJONVdv3+/Xho71IQziIbc5E
         JB+aSx88i6VDIWdXvcUlmrHgoHlbmwgyBdKWLLPocqN+hHdwBrtFY1bUpf2a2EIIAo
         2uEQgbIWVPLDg==
Date:   Mon, 20 Sep 2021 20:17:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH] fscrypt: remove fscrypt_operations::max_namelen
Message-ID: <YUlO1vmMXRaHHpTK@sol.localdomain>
References: <20210909184513.139281-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909184513.139281-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 09, 2021 at 11:45:13AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The max_namelen field is unnecessary, as it is set to 255 (NAME_MAX) on
> all filesystems that support fscrypt (or plan to support fscrypt).  For
> simplicity, just use NAME_MAX directly instead.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fname.c       | 3 +--
>  fs/ext4/super.c         | 1 -
>  fs/f2fs/super.c         | 1 -
>  fs/ubifs/crypto.c       | 1 -
>  include/linux/fscrypt.h | 3 ---
>  5 files changed, 1 insertion(+), 8 deletions(-)

Applied to fscrypt.git#master for 5.16.

- Eric
