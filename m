Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 401172B26CE
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 22:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgKMVbV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Nov 2020 16:31:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726397AbgKMVbU (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Nov 2020 16:31:20 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C7AD42224D;
        Fri, 13 Nov 2020 21:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605302503;
        bh=dYQRImEyN5cj+h8wBTyUJZe0tM3ebADwHoU+Rryy34E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bTXmg9RbSLNjEQOcOi8XDIqWyNZCeWfvQboiGZ0genEe7ZjmyE5kZs6yLTV/nDTjf
         MNJR4NbGjgEWR7hTSlkDJl4FqptAews1mrVGnAFVSheLyPppEkAAgs2rfx4ftU/W0h
         uST6rxGJEqv7lI7fXMSKW2mbmxyVaMq7RALac5wE=
Date:   Fri, 13 Nov 2020 13:21:41 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Victor Hsieh <victorhsieh@google.com>,
        Luca Boccassi <luca.boccassi@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH] fs-verity: rename fsverity_signed_digest to
 fsverity_formatted_digest
Message-ID: <X6745brG4qhs/OQn@sol.localdomain>
References: <20201027191106.2447401-1-ebiggers@kernel.org>
 <X67TSUuGngILe8Kk@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X67TSUuGngILe8Kk@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 13, 2020 at 10:41:13AM -0800, Eric Biggers wrote:
> On Tue, Oct 27, 2020 at 12:11:06PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The name "struct fsverity_signed_digest" is causing confusion because it
> > isn't actually a signed digest, but rather it's the way that the digest
> > is formatted in order to be signed.  Rename it to
> > "struct fsverity_formatted_digest" to prevent this confusion.
> > 
> > Also update the struct's comment to clarify that it's specific to the
> > built-in signature verification support and isn't a requirement for all
> > fs-verity users.
> > 
> > I'll be renaming this struct in fsverity-utils too.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> Applied to fscrypt.git#fsverity for 5.11.
> 
> - Eric

Actually, I decided to resend this as part of the series
https://lkml.kernel.org/linux-fscrypt/20201113211918.71883-1-ebiggers@kernel.org.

- Eric
