Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C7721A791
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 21:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGITKd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 15:10:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgGITKc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 15:10:32 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E16206A1;
        Thu,  9 Jul 2020 19:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594321832;
        bh=7KRMqy4oV6mS/Hoyk03KpqgmB/R5XX8qafjuJ1o72ro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I794ANyb2o0qg1OQXYqnhhASsMxXbe7xZ8Mg22LKRnYrvn2wW211ELNuNsQ0+YV9u
         Ye6FJWh4WAx2Q2ayJO3E9ugxRbVKwNV58QaPdzsW/2PdUKTYXMGJQ3RuGaOUa2emh4
         oT8saKG9HUWF8e3leW6KLi1ysrhCCdC7LutJFAK8=
Date:   Thu, 9 Jul 2020 12:10:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests-bld PATCH v2] test-appliance: exclude generic/587 from
 the encrypt tests
Message-ID: <20200709191031.GB3855682@gmail.com>
References: <20200709184145.GA3855682@gmail.com>
 <20200709185832.2568081-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709185832.2568081-1-satyat@google.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 09, 2020 at 06:58:32PM +0000, Satya Tangirala wrote:
> The encryption feature doesn't play well with quota, and generic/587
> tests quota functionality.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

Reviewed-by: Eric Biggers <ebiggers@google.com>
