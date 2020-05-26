Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18021E32D3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 May 2020 00:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404007AbgEZWnV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 May 2020 18:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403911AbgEZWnV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 May 2020 18:43:21 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2F34208C3;
        Tue, 26 May 2020 22:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590533001;
        bh=2L+6B0xcDMWWFKzDafu3+l7MFINByxs5xp8mPdOckkQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xFHO6hjvJ8EJu66PjNt9BXCXFT7Z9k/oAhuHsBEvQcULJdrGH4pgLXza1pHahBdwR
         Lx2sdEDRYDftMn5nv22wv882XvyuLmJZXBwfta81YtfzzcD/JL2FJX1h/anoQLoBE9
         gW36QsKzoZijyIORLWVpZHfUKH/j9DFivaFYNUDs=
Date:   Tue, 26 May 2020 15:43:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, jsorensen@fb.com, kernel-team@fb.com
Subject: Re: [PATCH v2 0/3] fsverity-utils: introduce libfsverity
Message-ID: <20200526224319.GA182086@gmail.com>
References: <20200525205432.310304-1-ebiggers@kernel.org>
 <4d485877-9506-b15a-f2f9-c087f1a5d8a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d485877-9506-b15a-f2f9-c087f1a5d8a2@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 26, 2020 at 06:25:22PM -0400, Jes Sorensen wrote:
> 
> One feature I would like to have, and this is what I confused in my
> previous comments. In addition to a get_digset_size() function, it would
> be really useful to also have a get_signature_size() function. This
> would be really useful when trying to pre-allocate space for an array of
> signatures, or is there no way to get that info from openssl without
> creating an actual signature?
> 

I don't think that's possible.

It's also not fixed for each hash algorithm, but rather it depends on the key
and certificate used.

- Eric
