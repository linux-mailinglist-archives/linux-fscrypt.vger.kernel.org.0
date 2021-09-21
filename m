Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1986412D75
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Sep 2021 05:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhIUDcO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Sep 2021 23:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229922AbhIUDPT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Sep 2021 23:15:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A80861050;
        Tue, 21 Sep 2021 03:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632194031;
        bh=4MNBP5Or6e6CSO6qkciRsrJs/FD/1so4A/h0yT3ltVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lC+KsZbvTWqTD6aLiB+fSH/wza2rnaSl5iFQ0GqjC9+bSMiUfY77eQ+enDog94kWi
         SkxjFKtlpQ+L6+vUwO+aXGAnuven8pUhjhpuNALP7NgJkRc1ilot/GILDbxOJgijVK
         KrTsWXHDKCJ+ninkCNlA3vXTBsXLQRUw5wrplhbi8HnKa7P1TMb75VhdbO1H5YfeKW
         kKPO0/B6XIYzCcy4eawJBznlaanfhmuuy1JTkPe2Ec/VoLdC/dGf8g/OY9IehIIDJS
         IiNI+1PbLlaNTY84bxahadFQhQpRMI3VDZQ62z47b7+I3LqJ6wQph7+5VQBrH1f64n
         kAv7KTzoFNdHA==
Date:   Mon, 20 Sep 2021 20:13:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, kernel-team@android.com,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Gaurav Kashyap <gaurkash@codeaurora.org>,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [RFC PATCH v2 3/5] fscrypt: improve documentation for inline
 encryption
Message-ID: <YUlN7TY7z5/2EcFF@sol.localdomain>
References: <20210916174928.65529-1-ebiggers@kernel.org>
 <20210916174928.65529-4-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916174928.65529-4-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 16, 2021 at 10:49:26AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Currently the fscrypt inline encryption support is documented in the
> "Implementation details" section, and it doesn't go into much detail.
> It's really more than just an "implementation detail" though, as there
> is a user-facing mount option.  Also, hardware-wrapped key support (an
> upcoming feature) will depend on inline encryption and will affect the
> on-disk format; by definition that's not just an implementation detail.
> 
> Therefore, move this documentation into its own section and expand it.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/block/inline-encryption.rst |  2 +
>  Documentation/filesystems/fscrypt.rst     | 73 +++++++++++++++++------
>  2 files changed, 58 insertions(+), 17 deletions(-)

I've applied this patch to fscrypt.git#master for 5.16, as it's a useful cleanup
which isn't dependent on the hardware-wrapped keys feature.

- Eric
