Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2F522E0E4A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Dec 2020 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgLVSlQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Dec 2020 13:41:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:54872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbgLVSlQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Dec 2020 13:41:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6F8222AB9;
        Tue, 22 Dec 2020 18:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608662436;
        bh=ocJKC0K2XskBJMvlJOq0KkfQy2flUmfksDVfV3URvto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h4jqPZDMJqmwbaB9iTgmw+i+ROp1uFKLXWenSe6wA4sZuL07vWP+8cQdmmzaxiPn3
         Nci/K7mizcYrSXN4EkuInki+R4gH74mP4UGY0zvCBU1uytuCH9rFbjon9poJzp67SI
         UOvG1RLKVONs5MU+KZTIMsENyPkO9uZMtzTgcBbT81Api0ha3ecp2JgqwHoGCMYSvO
         bUeCsQXPpdyFQbNstBf/187+omtyw8SiI1k3mA1wzOmKCUI6eyZrWY5rxalHdCJA45
         TI2+dEC6FA4R8gPuH4kn6MWWthGeDulaC6ifEH/QOtSqF1oU/UBvN3KTdp4RBxC27Z
         Pig+KJLSTvRZg==
Date:   Tue, 22 Dec 2020 10:40:34 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Luca Boccassi <bluca@debian.org>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v7 3/3] Allow to build and run sign/digest on Windows
Message-ID: <X+I9opcanpYVbJed@sol.localdomain>
References: <20201221232428.298710-1-bluca@debian.org>
 <20201222001033.302274-1-bluca@debian.org>
 <20201222001033.302274-3-bluca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201222001033.302274-3-bluca@debian.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 22, 2020 at 12:10:33AM +0000, Luca Boccassi wrote:
> Add some minimal compat type defs, and omit the enable/measure
> sources. Also add a way to handle the fact that mingw adds a
> .exe extension automatically in the Makefile install rules.
> 
> Signed-off-by: Luca Boccassi <luca.boccassi@microsoft.com>

Applied, thanks.

- Eric
