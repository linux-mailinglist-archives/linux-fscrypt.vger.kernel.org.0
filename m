Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36A682B51B5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Nov 2020 20:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731283AbgKPT5c (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 16 Nov 2020 14:57:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727393AbgKPT5b (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 16 Nov 2020 14:57:31 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F2E9208C7;
        Mon, 16 Nov 2020 19:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605556650;
        bh=6RPbSG5ZGTSSJuW1urRI9ZBEHEj5MnZv8gXJG/wiN6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BrHroKrhpagvLzB8zargNvVRoz06679F5N42v8zCP6bQjk3fPVCrN9hgEfTn18kuC
         ua+EKY1SJLQwNd/92GqsZrUr1i01Ha3D75s/v0xJY67rQXR3xbTu+Yw+xQgi6v7fN6
         3+Yixow9Po01WG+62ru+iCDKn6DLD429XSBPB48I=
Date:   Mon, 16 Nov 2020 11:57:28 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Victor Hsieh <victorhsieh@google.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Martijn Coenen <maco@android.com>,
        Paul Lawrence <paullawrence@google.com>
Subject: Re: [PATCH 0/4] fs-verity cleanups
Message-ID: <X7LZqLKKwtse2tWy@sol.localdomain>
References: <20201113211918.71883-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113211918.71883-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 13, 2020 at 01:19:14PM -0800, Eric Biggers wrote:
> This patchset renames some names that have been causing confusion:
> 
> - fsverity_signed_digest is renamed to fsverity_formatted_digest
> 
> - "fs-verity file measurement" is renamed to "fs-verity file digest"
> 
> In addition, this patchset moves fsverity_descriptor and
> fsverity_formatted_digest to the UAPI header because userspace programs
> may need them in order to sign files.
> 
> Eric Biggers (4):
>   fs-verity: remove filenames from file comments
>   fs-verity: rename fsverity_signed_digest to fsverity_formatted_digest
>   fs-verity: rename "file measurement" to "file digest"
>   fs-verity: move structs needed for file signing to UAPI header
> 
>  Documentation/filesystems/fsverity.rst | 68 ++++++++++++--------------
>  fs/verity/enable.c                     |  8 +--
>  fs/verity/fsverity_private.h           | 36 ++------------
>  fs/verity/hash_algs.c                  |  2 +-
>  fs/verity/init.c                       |  2 +-
>  fs/verity/measure.c                    | 12 ++---
>  fs/verity/open.c                       | 24 ++++-----
>  fs/verity/signature.c                  | 14 +++---
>  fs/verity/verify.c                     |  2 +-
>  include/uapi/linux/fsverity.h          | 49 +++++++++++++++++++
>  10 files changed, 116 insertions(+), 101 deletions(-)

All applied to fscrypt.git#fsverity for 5.11.  But as always, more reviews are
always appreciated.

- Eric
