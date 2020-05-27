Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B5F1E4FE3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 May 2020 23:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726129AbgE0VPq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 May 2020 17:15:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726114AbgE0VPq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 May 2020 17:15:46 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17F23207E8;
        Wed, 27 May 2020 21:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590614146;
        bh=7stj82ag5MXwtkPAcEcs4lmXI6Pu1ifSkzg6+307dp8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fQfS8pypqesugeRD1wPFBFLZYVJ9avI3D29Duc2bhoU4f+k/ZqhDd/QHZkjGpGBLJ
         PxrzH7CEyj2kaVsgcQHSqHz7OHyQTExJ6jPAG9LkCVmTZX1PanWoygz+vzjsmmkntf
         KpI2O3lOvHGam+S7/C5Rm1BmwLIVhSf66muS34gw=
Date:   Wed, 27 May 2020 14:15:44 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
Subject: Re: [PATCH v2 0/3] fsverity-utils: introduce libfsverity
Message-ID: <20200527211544.GA14135@sol.localdomain>
References: <20200525205432.310304-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525205432.310304-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 25, 2020 at 01:54:29PM -0700, Eric Biggers wrote:
> From the 'fsverity' program, split out a library 'libfsverity'.
> Currently it supports computing file measurements ("digests"), and
> signing those file measurements for use with the fs-verity builtin
> signature verification feature.
> 
> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
> I made a lot of improvements; see patch 2 for details.
> 
> This patchset can also be found at branch "libfsverity" of
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/
> 
> Changes v1 => v2:
>   - Fold in the Makefile fixes from Jes
>   - Rename libfsverity_digest_size() and libfsverity_hash_name()
>   - Improve the documentation slightly
>   - If a memory allocation fails, print the allocation size
>   - Use EBADMSG for invalid cert or keyfile, not EINVAL
>   - Make libfsverity_find_hash_alg_by_name() handle NULL
>   - Avoid introducing compiler warnings with AOSP's default cflags
>   - Don't assume that BIO_new_file() sets errno
>   - Other small cleanups
> 
> Eric Biggers (3):
>   Split up cmd_sign.c
>   Introduce libfsverity
>   Add some basic test programs for libfsverity
> 

Applied and pushed out to the 'master' branch.

- Eric
