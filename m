Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78B3DF6B6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2019 22:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730238AbfJUU1x (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Oct 2019 16:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729406AbfJUU1w (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Oct 2019 16:27:52 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0E6492067B;
        Mon, 21 Oct 2019 20:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571689672;
        bh=8L0ewzw/7ASjBk080cDN5cpuIRKTa15ov4LqNhbGUyU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XdtMEsZXZVkZi/8oM2C2wP4SMkBrcUEBcH7YoA38fZCsMykEa+h8l6fvBqs+UW7cf
         ATArblZlo/LZmMFIIeYmZTHsTcOSt1bCMO2wSrHqvrav3dPU/ruwbYJqEU1XJk3uXN
         wrdd0tiCZ11qo3ZLkz6RpfjgaTxP1Yfhb01SWRaE=
Date:   Mon, 21 Oct 2019 13:27:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-crypto@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] fscrypt: invoke crypto API for ESSIV handling
Message-ID: <20191021202749.GA122863@gmail.com>
Mail-Followup-To: linux-fscrypt@vger.kernel.org,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-crypto@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
References: <20191009233840.224128-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009233840.224128-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 09, 2019 at 04:38:40PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Instead of open-coding the calculations for ESSIV handling, use an ESSIV
> skcipher which does all of this under the hood.  ESSIV was added to the
> crypto API in v5.4.
> 
> This is based on a patch from Ard Biesheuvel, but reworked to apply
> after all the fscrypt changes that went into v5.4.
> 
> Tested with 'kvm-xfstests -c ext4,f2fs -g encrypt', including the
> ciphertext verification tests for v1 and v2 encryption policies.
> 
> Originally-from: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Applied to fscrypt.git for 5.5.

- Eric
