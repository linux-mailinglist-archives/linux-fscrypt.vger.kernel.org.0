Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC416473A7C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Dec 2021 02:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243294AbhLNBxU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Dec 2021 20:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237640AbhLNBxT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Dec 2021 20:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55012C061574;
        Mon, 13 Dec 2021 17:53:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 057D2B817A3;
        Tue, 14 Dec 2021 01:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E25C34600;
        Tue, 14 Dec 2021 01:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639446796;
        bh=ugiwLO/eTTYuTBk9/pl5AEJ/eQZv3n3nqOB/N/SHVD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c7xwA6pCfXWxDSJKMueSRZamzI4WFFdFRmzEoCi3WNZe3L4Iu8FoK4nD++Z8DuszL
         82Xwhr0rS7r6boPnXg9w3WrKiSaIvzd1emgecg8L4IzLcIkBfyB6sM4nutrrJ7M87L
         n/DRYmGAnRmbovBBa7QUQcXN2gi1N4KQlxRgoUaBc6+kacIdrxFQIIXaSENPyb6U7E
         YGtGZ+8PlV55+4JU7nBCmuYO+DeLgeDyBRu8c6UdnzxA1yalWlNIqp5UzEFP0ykRnS
         NrUfVoUTDvZProii2XLR3e79gEC8ojGns5n3z6aA2vfEm0qRv6fRTys1LUI38/LV4N
         wxzCueIij0HGA==
Date:   Mon, 13 Dec 2021 17:53:15 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc:     linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, thara.gopinath@linaro.org,
        quic_neersoni@quicinc.com, dineshg@quicinc.com
Subject: Re: [PATCH 08/10] scsi: ufs: add support for generate, import and
 prepare keys
Message-ID: <Ybf5C4v+r6CrXKD/@gmail.com>
References: <20211206225725.77512-1-quic_gaurkash@quicinc.com>
 <20211206225725.77512-9-quic_gaurkash@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206225725.77512-9-quic_gaurkash@quicinc.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 06, 2021 at 02:57:23PM -0800, Gaurav Kashyap wrote:
> This patch contains two changes in UFS for wrapped keys.
> 1. Implements the blk_crypto_profile ops for generate, import
>    and prepare key apis.
> 2. Adds UFS vops for generate, import and prepare keys so
>    that vendors can hooks to them.
> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>

When adding things to ufs_hba_variant_ops, it would helpful to explain why they
belong there.  It's because this stuff isn't part of the UFS standard, right?

- Eric
