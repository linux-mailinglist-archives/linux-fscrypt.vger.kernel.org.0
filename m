Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB1F8E0AC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 00:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbfHNW3s (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Aug 2019 18:29:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728262AbfHNW3s (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Aug 2019 18:29:48 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4B022064A;
        Wed, 14 Aug 2019 22:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565821787;
        bh=syd00LH0A8VQv71UJv1kxHWmlo9jfVvUi/NiMOUQX5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HWtgHtovPNmk5cKGn6LAGqRcda7GdWSbbKWX+8s9W3iVH/aDeYDFaaoyVc2RDyICG
         NP0vKzLlZJYrl94vk0sUNDbfqslBzuQ/7D0ZnsoK7ch+HtVxpdhKWnxlDLIF8xLBFc
         dG7xlpQhLrCSWUP/OF6fgH0sWDPkN3+gme0GLZtQ=
Date:   Wed, 14 Aug 2019 15:29:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     Chandan Rajendra <chandan@linux.ibm.com>
Subject: Re: [PATCH] fscrypt: remove loadable module related code
Message-ID: <20190814222945.GB101319@gmail.com>
Mail-Followup-To: linux-fscrypt@vger.kernel.org,
        Chandan Rajendra <chandan@linux.ibm.com>
References: <20190724194438.39975-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190724194438.39975-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jul 24, 2019 at 12:44:38PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since commit 643fa9612bf1 ("fscrypt: remove filesystem specific build
> config option"), fs/crypto/ can no longer be built as a loadable module.
> Thus it no longer needs a module_exit function, nor a MODULE_LICENSE.
> So remove them, and change module_init to late_initcall.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied to fscrypt tree for 5.4.

- Eric
