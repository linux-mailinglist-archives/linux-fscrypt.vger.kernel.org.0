Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D156C12A452
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Dec 2019 23:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbfLXWi4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 24 Dec 2019 17:38:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:40852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726224AbfLXWi4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 24 Dec 2019 17:38:56 -0500
Received: from zzz.localdomain (h75-100-12-111.burkwi.broadband.dynamic.tds.net [75.100.12.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBA28206CB;
        Tue, 24 Dec 2019 22:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577227135;
        bh=ceZe6wzbsWb7YfJCW2iWlROm560ptqJ0gDAZzE4x2lA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U2ginxI6Gddm3gNHE0cVgJuDbWTAJNNVOwtSy65sIerTXwyxqXe6p7DbFRneug/fe
         GQ2j4xtjMmh6Fdz4hUhO/QrqUBEzgHL/LKwddhUnF+7ExMxRBmQxNzGm6bTfcD+wdP
         srIQ4YLgfoX7sKQFBEzbviKeoKjk/e6OihgphRSk=
Date:   Tue, 24 Dec 2019 16:38:52 -0600
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [v3 PATCH] fscrypt: Allow modular crypto algorithms
Message-ID: <20191224223852.GA178036@zzz.localdomain>
References: <20191221143020.hbgeixvlmzt7nh54@gondor.apana.org.au>
 <20191221234428.GA551@zzz.localdomain>
 <20191222084155.n4mbomsw6pl4c7kv@gondor.apana.org.au>
 <20191222164545.GA157733@zzz.localdomain>
 <20191223074623.you4ivf2yuxk4ad2@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191223074623.you4ivf2yuxk4ad2@gondor.apana.org.au>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 23, 2019 at 03:46:23PM +0800, Herbert Xu wrote:
> diff --git a/fs/ext4/Kconfig b/fs/ext4/Kconfig
> index ef42ab040905..930793456d3a 100644
> --- a/fs/ext4/Kconfig
> +++ b/fs/ext4/Kconfig
> @@ -10,6 +10,7 @@ config EXT3_FS
>  	select CRC16
>  	select CRYPTO
>  	select CRYPTO_CRC32C
> +	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>  	help
>  	  This config option is here only for backward compatibility. ext3
>  	  filesystem is now handled by the ext4 driver.

This needs to be under EXT4_FS, not EXT3_FS.  That should address the kbuild
test robot error.

(The fact that EXT3_FS selects options other than just EXT4_FS is unnecessary
and misleading; I'll send a separate patch to clean that up.)

- Eric
