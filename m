Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1866F2993E1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 18:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770631AbgJZRca (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 13:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407989AbgJZRca (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 13:32:30 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFFFA20732;
        Mon, 26 Oct 2020 17:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603733549;
        bh=/wiZL6aVxVQjIk4PzZVfKf4Y/wDE1eeDx70+yDpM2Ag=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JcgMiTr8lr4tjfd3HtGl/RA5G/OkBSWZlYGXlid8mOCzvY0x9GtLKlaJpw4+NySwQ
         v6hhm3fgt/y8EPb44evG4Bqq5nmn103qgblcatop/J/0yyc74+lwkYqqEuQFoW8IWP
         RSUwIpHCtzxYvVevSP96EUb9t9X/atysk1YGKSz8=
Date:   Mon, 26 Oct 2020 10:32:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v2 1/2] Use pkg-config to get libcrypto
 build flags
Message-ID: <20201026173228.GD858@sol.localdomain>
References: <20201022175934.2999543-1-luca.boccassi@gmail.com>
 <20201026111506.3215328-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026111506.3215328-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 26, 2020 at 11:15:05AM +0000, luca.boccassi@gmail.com wrote:
> From: Luca Boccassi <luca.boccassi@microsoft.com>
> 
> Especially when cross-compiling or other such cases, it might be necessary
> to pass additional compiler flags. This is commonly done via pkg-config,
> so use it if available, and fall back to the hardcoded -lcrypto if not.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>

Applied with one fixup.  Thanks!

- Eric
