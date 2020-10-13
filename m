Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE8728D316
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Oct 2020 19:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbgJMRZP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Oct 2020 13:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:43616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729800AbgJMRZP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Oct 2020 13:25:15 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 809C325352;
        Tue, 13 Oct 2020 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602609914;
        bh=V95KNOynADgyNJkbMcakWMDVLJhk1UkWeH59c6nVuF8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=srAc5VjgMBfmXT/SLN9eUj3vHn2r18dijjjTZjQ7fH3zOdvMA4D7GWBAWQ41fmEA4
         bBJAu1RcGOJyHOgBaVmYu/J5NiAU3j74lFSETJRXzR5rJDnUkax1VhURLUOYqD2EFw
         jhcGriTvK3wF0rLsd7pgqlMCGvVZ11T7bUymUWaM=
Date:   Tue, 13 Oct 2020 10:25:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 35/80] docs: fs: fscrypt.rst: get rid of :c:type: tags
Message-ID: <20201013172512.GA1306858@gmail.com>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
 <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ca36d4903a6c024c7605cd58eab417c8e5296b5.1602589096.git.mchehab+huawei@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 13, 2020 at 01:53:50PM +0200, Mauro Carvalho Chehab wrote:
> The :c:type: tag has problems with Sphinx 3.x, as structs
> there should be declared with c:struct.
> 
> So, remove them, relying at automarkup.py extension to
> convert them into cross-references.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

I left some comments on v5 which weren't addressed.

- Eric
