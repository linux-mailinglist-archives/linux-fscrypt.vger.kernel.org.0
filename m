Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111374A5430
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Feb 2022 01:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbiBAAgy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 19:36:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57896 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiBAAgy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 19:36:54 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E505B82CD0;
        Tue,  1 Feb 2022 00:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D090DC340EC;
        Tue,  1 Feb 2022 00:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643675810;
        bh=MGKv0sfozx8gNMHDpdIgyk/dR4i+ORh1vcwM0odJcpo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CkzckEaGKNDzWeQuND5kVtIDUOgJs/T4hxAC4n2VFBWafAGnMAzJgHMsVzrIg97Ay
         U0ySz1GYbCcgUgyHrCfoEhPaaZVAdPpjEgWcKJHZ6r26p2rf6cLNWsMEsr2qUGskWI
         D/OAfYRiJdwe7RC3YjjnAYWp4sD12xhtdTQegY0CwuvSFtvMYwkFzaHmAF/BKND9vg
         CeoZQhU1vzX1SLMcPqLgRmUeWTaR0MZYlrm4jLz1nXOvwxgVlrHn5gKwFti+E0tYCh
         lkBUFUcYmweJ2PRoKTPErekKjpI/ApuoGy079+m4oMgmFKA8AGoOCdEIhfzb/dvYqS
         L4qsoDtTLxktQ==
Date:   Mon, 31 Jan 2022 16:36:48 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/8] ima: support fs-verity digests and signatures
Message-ID: <YfiAoKiFdkXte7PW@sol.localdomain>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126000658.138345-1-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 25, 2022 at 07:06:50PM -0500, Mimi Zohar wrote:
 
> Support including fs-verity file digests in the 'd-ng' template field
> based on a new policy rule option named 'digest_type=hash|verity'.

Perhaps it should be full_hash or verity?  verity is a type of hash.

- Eric
