Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7D295265
	for <lists+linux-fscrypt@lfdr.de>; Wed, 21 Oct 2020 20:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440774AbgJUSqy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 21 Oct 2020 14:46:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:53378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436568AbgJUSqy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 21 Oct 2020 14:46:54 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E7F922456;
        Wed, 21 Oct 2020 18:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603306013;
        bh=NoLMYTXbrovew7WM91LBaZpPU9YA1jHiL7nszKMwBWM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wFAvTbvIE5tgZRcXKflGfrNeOk5A2vqs7HQ2gBm2h8t301rX30tug6Q0djXDcIx+2
         DKntu1ew6DXsbVG7r6FoWPyccd/8Porw05fGByje96TE9EdwlVNTBSeo3hYSNYNrFX
         yVrUmHi6vSlmMAWpatzirI2ep/2ycmhs2EnW3XWc=
Date:   Wed, 21 Oct 2020 11:46:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH] Makefile check: use LD_LIBRARY_PATH with
 USE_SHARED_LIB
Message-ID: <20201021184651.GA2326972@gmail.com>
References: <20201020171110.2718640-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020171110.2718640-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 20, 2020 at 06:11:10PM +0100, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> When USE_SHARED_LIB is set, the fsverity binary is dynamically linked,
> so the check rule fails. Set LD_LIBRARY_PATH to the working directory.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>

Applied, thanks.

- Eric
