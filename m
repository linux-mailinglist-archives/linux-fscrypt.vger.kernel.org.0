Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4FC1C97F2
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 19:35:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgEGRfk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 13:35:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbgEGRfk (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 13:35:40 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4CC221473;
        Thu,  7 May 2020 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588872939;
        bh=IP9n/bKCm1JKZcnHSK6gU2nwe9gJBisW0YU71xwHyQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FKJ1DRijrJXWFjVuhjqemiL9mOEIcE/bA+nD0kjZwXfeTSKossXxdaGnGolp0U+lF
         mrEHtsHnDVxltZV+cSDDcV45J2LoYOPvGKgq5dn7K39O1mZo/811AyUYpXptqTrWjA
         tdMQDMQE4lsK//8PJo6o7o6s4615vEZX8Q+Zg6s8=
Date:   Thu, 7 May 2020 10:35:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jsorensen@fb.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 00/20] Split fsverity-utils into a shared library
Message-ID: <20200507173538.GA236103@gmail.com>
References: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
 <81e0cd1f-620e-5ac1-4de5-1d9bbafde8cb@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81e0cd1f-620e-5ac1-4de5-1d9bbafde8cb@fb.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 07, 2020 at 10:03:47AM -0400, Jes Sorensen wrote:
> On 4/24/20 4:54 PM, Jes Sorensen wrote:
> > From: Jes Sorensen <jsorensen@fb.com>
> > 
> > Hi
> > 
> > This is an update to the libfsverity patches I posted about a month
> > ago, which I believe address all the issues in the feedback I received.
> 
> Hi Eric,
> 
> Wanted to check in and hear if you had a chance to look at this?
> 
> Thanks,
> Jes
> 

No, it's on my list of things to review though.

- Eric
