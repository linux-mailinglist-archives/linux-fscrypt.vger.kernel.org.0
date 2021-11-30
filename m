Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC29462CC7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 07:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbhK3Gdl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 01:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230443AbhK3Gdk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 01:33:40 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36728C061574;
        Mon, 29 Nov 2021 22:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1B438CE13F9;
        Tue, 30 Nov 2021 06:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEBBC53FC1;
        Tue, 30 Nov 2021 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638253818;
        bh=aSy6X/HLpYqWHn8R4RV3gb/OanP+Jqq/AK5b1UPu5R8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JxucHg7L/glFjCmLPDqUkT/3WAgRhaVe0utUdCdU3o/GsakEVaNzn1jm5uAtDpzee
         Leb8YLsOmuOHPuWNT/SAq3o6enMT5/eSP/eyal4H/WCtc7OMa6LyHtbZnA1813XIiz
         5z+erwNVVMo31Gm+aBcm68QfvPln+RKGBkE8ba8qV9+HJ2HgrclhoFH+F4LtqQxzth
         qq5BNl8QJkEa+Dns9K8C4KEqTLjYMRoaj4a8MQiv57EFxd33txMNh/d7SaMFdbGlBZ
         eTRJkX0A/pnQAd0HEUkh7lLGOYxBkN2QlODZHkS4oSIzWf/t9dP4qyZbZUZYL5zPiG
         5/EKVCUGvl/8A==
Date:   Mon, 29 Nov 2021 22:30:16 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Cc:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fs-verity: define a function to return the integrity
 protected file digest
Message-ID: <YaXE+H17xPZSEcP7@sol.localdomain>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-2-zohar@linux.ibm.com>
 <YaWKJEqD6G23uG/A@sol.localdomain>
 <53ee68b8-e3fe-887c-89d3-a327c8dc181f@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53ee68b8-e3fe-887c-89d3-a327c8dc181f@linux.microsoft.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 29, 2021 at 09:33:29PM -0800, Lakshmi Ramasubramanian wrote:
> > > +/**
> > > + * fsverity_measure() - get a verity file's digest
> nit: The function name seems to suggest it is measuring the fs-verity file's
> digest. Since it is reading the file's digest: fsverity_read_digest() or
> fsverity_read_measure()?

I suggest fsverity_get_digest().  "read" is misleading because it's not being
read from disk.

- Eric
