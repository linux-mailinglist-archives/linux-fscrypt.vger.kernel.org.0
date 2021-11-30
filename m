Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0505F462A9D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 03:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbhK3CkS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Nov 2021 21:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbhK3CkS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Nov 2021 21:40:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027BAC061574;
        Mon, 29 Nov 2021 18:36:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A365EB80D1E;
        Tue, 30 Nov 2021 02:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AE5C53FAD;
        Tue, 30 Nov 2021 02:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638239817;
        bh=HeQc/9NihZ7cBBi42KaXPDogv19hU3v73HAJN/cZTSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OucQndYxihrnoGB8UuFkyVfSlw+qCcbsgUV1hFo2NR0p3FSag1Orw2LQ3HtT3rccx
         Aiz919dkGGbHD89tFspPtN6zSQ+YG8PFI7B5O4+cRDtZ4GRWRAPOwVdXoNHtjGmxu6
         g3zeRuL13ny0uxSPpS5h0yzXL+4IT8daBLBnfNiau3Xb9O7l2VsWggnybWl2jACwBH
         YLRvqk5JWkibkWV8REUfGC351Lo+X4sV/nmM+ua6sloWGL+AbMqk4F+Oocmi694LO+
         Olk7JW2raKX5KwdHTQyQ+qwufMzZOTwh+kbOC55/qRE04xrRFBkb3IxY4lP4EANReM
         4TlUg90wmcCtQ==
Date:   Mon, 29 Nov 2021 18:36:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] ima: support fs-verity signatures stored as
Message-ID: <YaWOR+Bav6PBgHHq@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211129170057.243127-1-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 29, 2021 at 12:00:53PM -0500, Mimi Zohar wrote:
> Support for fs-verity file digests in IMA was discussed from the beginning,
> prior to fs-verity being upstreamed[1,2].  This patch set adds signature
> verification support based on the fs-verity file digest.  Both the
> file digest and the signature must be included in the IMA measurement list
> in order to disambiguate the type of file digest.
> 
> [1] https://events19.linuxfoundation.org/wp-content/uploads/2017/11/fs-verify_Mike-Halcrow_Eric-Biggers.pdf
> [2] Documentation/filesystems/fsverity.rst
> 
> Mimi Zohar (4):
>   fs-verity: define a function to return the integrity protected file
>     digest
>   ima: define a new signature type named IMA_VERITY_DIGSIG
>   ima: limit including fs-verity's file digest in measurement list
>   ima: support fs-verity file digest based signatures
> 
>  fs/verity/fsverity_private.h              |  6 ---
>  fs/verity/measure.c                       | 49 +++++++++++++++++++++++
>  include/linux/fsverity.h                  | 17 ++++++++
>  security/integrity/ima/ima.h              |  3 +-
>  security/integrity/ima/ima_api.c          | 23 ++++++++++-
>  security/integrity/ima/ima_appraise.c     |  9 ++++-
>  security/integrity/ima/ima_main.c         |  7 +++-
>  security/integrity/ima/ima_template_lib.c |  3 +-
>  security/integrity/integrity.h            |  1 +
>  9 files changed, 107 insertions(+), 11 deletions(-)

I left some comments, but this generally looks like the right approach.
However, I'm not an expert in IMA, so it's hard for me to review the IMA parts.

Can you add documentation for this feature?

- Eric
