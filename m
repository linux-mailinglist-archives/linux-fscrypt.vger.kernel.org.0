Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549652E0726
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 09:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbgLVIWb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Dec 2020 03:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:42274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgLVIWb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Dec 2020 03:22:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D47723137;
        Tue, 22 Dec 2020 08:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608625311;
        bh=3K+z5iwSK2SHSTl1d3ws5bU3rEgsYGn5KMXWJTGsgEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fzdxQts3EeYSbDojVU7sWuAUR35ApYhqRN2vq6ZS3VhwHtoIJA6zXGpZ06d/Mimkx
         UDS85yVbwBwR+Za7RKjc8pb+NIjB3/B34c/f3MNQdVk2Ix6+BK8UKZuOFwwLCwAGm3
         dw41BBhwLt0RRTdm9bg5VWcmzr1yW4CEo5SJw/0qTWifzriOe0/fo8EJuTV6CAs5y3
         AhXCWk525IJHrHi1DnvRTupMH9xcgxgGrFoB2GPHhrMnrUOxTduYwJ3CuwVflSKO9t
         HPyp3Iv0SgW3bq35vRuDkdnFiYdDsU1fL57CKkLKSb3IJR7LiRXULw/pl7t2MamfS6
         P2PbfPueltMfw==
Date:   Tue, 22 Dec 2020 00:21:49 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Move -D_GNU_SOURCE to CPPFLAGS
Message-ID: <X+Gsnc6g3L5MPdAA@sol.localdomain>
References: <20201221232428.298710-1-bluca@debian.org>
 <20201222001033.302274-1-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222001033.302274-1-bluca@debian.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 22, 2020 at 12:10:31AM +0000, Luca Boccassi wrote:
> Use _GNU_SOURCE consistently in every file rather than just one file.
> This is needed for the Windows build in order to consistently get the MinGW
> version of printf.
> 
> Signed-off-by: Luca Boccassi <bluca@debian.org>

Is this the email address you wanted to use in the Author and Signed-off-by?
v5 and earlier (and your other patches) had "luca.boccassi@microsoft.com".

- Eric
