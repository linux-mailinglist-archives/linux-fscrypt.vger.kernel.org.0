Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC4E2B23EF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 19:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgKMSlP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 13:41:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:34456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgKMSlP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 13:41:15 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2C60206FB;
        Fri, 13 Nov 2020 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605292874;
        bh=ThIZM+CHKYHasNz7XR8SeNNGfdpmMRkxt6TFb7eTJX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NiwJjAMAK08uwFi8YcHBvkgwNHDrkQXh44IBQi1qv+IaBXc7Gjone8GQdy92G+vxb
         UVe8mN/riRRSpfTbF2aF6ER61N5bCXln4Dk6AcVyFsMO4XFmEvrmCtsgqsYS1UOzOz
         vjuDbCKCri/tG5njxWUCCMfFDGHxUewVPtl7+OSQ=
Date:   Fri, 13 Nov 2020 10:41:13 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] fs-verity: rename fsverity_signed_digest to
 fsverity_formatted_digest
Message-ID: <X67TSUuGngILe8Kk@sol.localdomain>
References: <20201027191106.2447401-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027191106.2447401-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 27, 2020 at 12:11:06PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The name "struct fsverity_signed_digest" is causing confusion because it
> isn't actually a signed digest, but rather it's the way that the digest
> is formatted in order to be signed.  Rename it to
> "struct fsverity_formatted_digest" to prevent this confusion.
> 
> Also update the struct's comment to clarify that it's specific to the
> built-in signature verification support and isn't a requirement for all
> fs-verity users.
> 
> I'll be renaming this struct in fsverity-utils too.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt.git#fsverity for 5.11.

- Eric
