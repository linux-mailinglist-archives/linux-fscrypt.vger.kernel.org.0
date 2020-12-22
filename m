Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842502E0E4B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 19:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbgLVSls (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Dec 2020 13:41:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:54890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgLVSlr (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Dec 2020 13:41:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A104229C5;
        Tue, 22 Dec 2020 18:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608662467;
        bh=8TK0HuJ0WplUr0zH3LmCWor6WMvlLrBHEZfiBlOrl5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JmIv5L03vwcFDb+jEjA+BEwuoh/dEryrzoTeRMeaDTIZcApEKj/2yAcOba73oD7tU
         JKfEp40jPXwqLbWc2AaDb4/uAACIih4Se42HVcUMHYUVrLEiBmg8fxnUn+EQPYk0Er
         P2SR3SgJLufokFDP08OKb7zCdsOFx6CpeAXzyb3xDFmj8itR3e9na46ZnLqjrQB39T
         6Khmx2Cl7cLK7+3PpQhvUC1lRmWXe29hREiOuLMRJjoVu0VZP7TJ8FTHj2w6FvT5jJ
         OCjymvqxCzqCFowBChWkbCtEObVUqtwSINYCIiPFcmM7pEU35fdo0c0SKQ0a+sl2W1
         vzjHba5GNDHZw==
Date:   Tue, 22 Dec 2020 10:41:05 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v7 2/3] Wrap ./fsverity in TEST_WRAPPER_PROG too
Message-ID: <X+I9wT9/o7EA8xWr@sol.localdomain>
References: <20201221232428.298710-1-bluca@debian.org>
 <20201222001033.302274-1-bluca@debian.org>
 <20201222001033.302274-2-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222001033.302274-2-bluca@debian.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 22, 2020 at 12:10:32AM +0000, Luca Boccassi wrote:
> Allows make check to run fsverity under the desired tool
> 
> Signed-off-by: Luca Boccassi <bluca@debian.org>
> ---
> v6: split from mingw patch
> 
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied, thanks.

- Eric
