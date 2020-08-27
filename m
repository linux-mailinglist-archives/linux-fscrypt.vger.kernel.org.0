Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30DB12547D0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Aug 2020 16:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbgH0Oyc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Aug 2020 10:54:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:21018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727124AbgH0NLT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Aug 2020 09:11:19 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07RD2ufG012233;
        Thu, 27 Aug 2020 09:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=0jkqVoBjl8OMYPBJk+Af10MNs/hhkJn3XMX7JyTNZv0=;
 b=j/lZ/Af1YQYbHrk2TkKLQORvKEvSvMnIGPM0g0J5ELCxZBP8j7HzCqN88vu+zGU3C/+u
 20QFxnEQPqRZ0hcj/cey8PqreSuIlmOm87Yti909JFIBWMSIDBo/LKdZSx3yGLxEY7oh
 qK8vc3JCLi2TDZdY4/+Rpw1U9eJGOle4WUU6yIo5Ikh9LYUVhyf6GsMUVNpbmdlrhyzt
 PFG2gEWG7srycZwzC9OHpxupPh/A8cvfiX5UbVnPXiyyDlWeGaQ7naINTBIOuwdnZmXO
 jKFxwnOdi83afgkys0OI3r2UFez0pSUoedr5UkLfPN4alWBfWHL2e5QQvWpEpEonr4/X LA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336aeke0ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 09:10:58 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07RD3ASq013524;
        Thu, 27 Aug 2020 09:10:57 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 336aeke0au-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 09:10:57 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07RD9Hm4020543;
        Thu, 27 Aug 2020 13:10:55 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 335j270xrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 13:10:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07RD9MsH62521618
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 13:09:22 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EF9852078;
        Thu, 27 Aug 2020 13:10:52 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.160.6.101])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 0882952079;
        Thu, 27 Aug 2020 13:10:50 +0000 (GMT)
Message-ID: <b5f33cb7880932bc1e6bbd3d3988bfad3e943036.camel@linux.ibm.com>
Subject: Re: IMA metadata format to support fs-verity
From:   Mimi Zohar <zohar@linux.ibm.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Chuck Lever <chuck.lever@oracle.com>,
        linux-fscrypt@vger.kernel.org, linux-integrity@vger.kernel.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Matthew Garrett <mjg59@google.com>
Date:   Thu, 27 Aug 2020 09:10:50 -0400
In-Reply-To: <20200827010016.GA2387969@gmail.com>
References: <760DF127-CA5F-4E86-9703-596E95CEF12F@oracle.com>
         <20200826183116.GC2239109@gmail.com>
         <6C2D16FB-C098-43F3-A7D3-D8AC783D1AB5@oracle.com>
         <20200826192403.GD2239109@gmail.com>
         <E7A87987-AF41-42AC-8244-0D07AA68A6E7@oracle.com>
         <20200826205143.GE2239109@gmail.com>
         <ced0c57308b0056396d4795a639e6d9686f0e163.camel@linux.ibm.com>
         <20200827010016.GA2387969@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-12.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_07:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=947
 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270094
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2020-08-26 at 18:00 -0700, Eric Biggers wrote:
> On Wed, Aug 26, 2020 at 08:53:33PM -0400, Mimi Zohar wrote:
> > On Wed, 2020-08-26 at 13:51 -0700, Eric Biggers wrote:
> > > Of course, the bytes that are actually signed need to include not just the hash
> > > itself, but also the type of hash algorithm that was used.  Else it's ambiguous
> > > what the signer intended to sign.
> > > 
> > > Unfortunately, currently EVM appears to sign a raw hash, which means it is
> > > broken, as the hash algorithm is not authenticated.  I.e. if the bytes
> > > e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 are signed,
> > > there's no way to prove that the signer meant to sign a SHA-256 hash, as opposed
> > > to, say, a Streebog hash.  So that will need to be fixed anyway.  While doing
> > > so, you should reserve some fields so that there's also a flag available to
> > > indicate whether the hash is a traditional full file hash or a fs-verity hash.
> > 
> > The original EVM HMAC is still sha1, but the newer portable & immutable
> > EVM signature supports different hash algorithms.
> > 
> 
> Read what I wrote again.  I'm talking about the bytes that are actually signed.

I agree including the hash algorithm in the digest would be
preferrable, but it isn't per-se broken.   The file signature and the
file metadata hash algorithms are the same, otherwise signature
verification fails[1].   The same tool calculates the file metadata
digest and then signs the digest, using the same hash algorithm.  In
terms of the HMAC, it is (still) limited to SHA1.

Mimi

[1] commit 5feeb61183dd ("evm: Allow non-SHA1 digital signatures")

