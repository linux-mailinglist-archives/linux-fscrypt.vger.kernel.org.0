Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 973424041D0
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 01:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348066AbhIHXdk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Sep 2021 19:33:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3280 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348062AbhIHXdk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Sep 2021 19:33:40 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 188NTQdd016691
        for <linux-fscrypt@vger.kernel.org>; Wed, 8 Sep 2021 16:32:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=zlx0KU6DOL6jZEZ90ESX3Pl1I51YcCmV+63QwmPkvRA=;
 b=lyIPFCABLVVHQMlQsXpo3Hm3Jm/QhY3ZIwTWczwxnCUdX3+Rf9sg6Ju7unGT8P6njD0G
 egacjOGyM6G32eF1JZTgpzYux7QanB9OZ9odBxcNZjLxuE5dEfe3q0gf5Rqu+6VFrHzc
 W2vxOTI4xPoP3+fz75X8aei0lKUUoIUaeGE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3axcpj9fn6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Sep 2021 16:32:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Wed, 8 Sep 2021 16:32:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fu4b0JbCjubgQEhOSZuSERLbpPcbcL/QDRmeGyP6s1Ld784DdrMZMsz8QCk9aJ2azXu1qGg5yt364KrOGoGhIHllVMV9Ey0sPGOz9eRRg3aUkFOypgJ2nGxfaiS0DBaaS6TjN1F7xUCzdPQjxUKll850zQeN9G3cghlW2ZDeyMFWCAiNp5lPqL7b/iyHZKtemQt+fLvZP2/FgSKL7Ijl8Nmvzd7HwFUF8kCbSgR7c1srTUislqLSwHn2eZs0zbDyPJR8SbgLF7+j9BtL/1JIIChPH7JKB7ojU3J7tSpWZ4c9kvqcGcVLyjnE13Gw1mrqP9b0VYeKPBm+4xpKR/zmdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=zlx0KU6DOL6jZEZ90ESX3Pl1I51YcCmV+63QwmPkvRA=;
 b=b5UWq8GswC6APE1ZFUCaG2blYZ9yUZuaKg85SoQJl4+kO6k92ENn6sO1qdiLU42CAHSBgTRz8cVMtj1PNAmZdcwlGbtRElekG3MDUk/krSNB32o6X+pGLCJ+U4BLC1PsRoEhnKFxUbBp1tD9EUdRIPljGhCFdh4HKoa2/XFg3z+Aths+U8wPlRiB99xN3IPUIEIiWEVXAuql+/OeR77rzBWebSheUbBimS23N0sM8fNn88eWnMP+459Ki0tCmoUkaqw1uZ6Ub5aQUhuVaHw4scPcHZCUCnOoPbyje23g//3tVY95P7YFVR4CeF3atc/ZqWS0L5813dq19mushHXyKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB4824.namprd15.prod.outlook.com (2603:10b6:806:1e3::15)
 by SA0PR15MB3856.namprd15.prod.outlook.com (2603:10b6:806:86::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 8 Sep
 2021 23:32:29 +0000
Received: from SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7]) by SA1PR15MB4824.namprd15.prod.outlook.com
 ([fe80::e438:ebd:8fbf:1ed7%8]) with mapi id 15.20.4500.016; Wed, 8 Sep 2021
 23:32:29 +0000
From:   Aleksander Adamowski <olo@fb.com>
To:     Eric Biggers <ebiggers@kernel.org>
CC:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Topic: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Thread-Index: AQHXm6xcGarxStMvPUS3MVkBynObEauaztiAgAAMJng=
Date:   Wed, 8 Sep 2021 23:32:29 +0000
Message-ID: <SA1PR15MB48240CCB6C38535A022ACADBDDD49@SA1PR15MB4824.namprd15.prod.outlook.com>
References: <20210828013037.2250639-1-olo@fb.com> <YTk806ahPPcuz9gl@gmail.com>
In-Reply-To: <YTk806ahPPcuz9gl@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 3bc8c5da-1907-14a7-4c28-378978274411
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 73d64e34-b097-4d4f-02aa-08d97320eca9
x-ms-traffictypediagnostic: SA0PR15MB3856:
x-microsoft-antispam-prvs: <SA0PR15MB38560D6178DA73289C331942DDD49@SA0PR15MB3856.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aWCCNkCqfK9cYQ9b5Gexa7ylVQdCFhCxmerRAR1K3mC37izvV5dr87mqQKVqu3cuEkIrMwnZfnaZEuxB+WDSR39dLQVdZJMfZyS1xElYd7DA8rT0O62AndpoRWsgykCRNCp1vhIrvyyDrvBMAA3r4emw1eo2E1EI/wdqB5sqQ4dpRY9Xezs3eIwZWH6JXHJTgl6iJc9Shak8gpDSvbpLXdLTqftLebbvnTwdywLKXVIeMYl0mNLv/9MlHFPC+sbjbJWa2fL6L5OGD8StVS/sKRjFZMQZaS9JjKX+5StDXqSz3uWlG1VA0P57OOGl3++ZdBLhtyMGjOu78/8Gj1VH8HAb3uS+TJzbnmvMCOHJB+7KNOOU1z4eLkYXwJuw/T8H8jUclsMjgITlEwRE75lfaGF2CSArVGUm7YtrVPI9XsVD6iZQk5A45RnA8MX5ZnsU5ETv/hSajGL5p7j6YM6XsRaC2bUncuyHAT+btNUGxlhG9kSx4C5jyr3o77byR426JGn3PnJuW5kvmq2LnWxfvH3Je9tyrXcmWBuAoe8q+dAZOZVYD6dVcuDNha7LStWTfLxwdsR+7dK55LUsgh1ecFOKguKkl81iYe/jSPkYqItYd9e/6wH6x3QOcCWVW0jy2nrzSmlCNDbG6DrISRH2RP4lXMZw8DFYCe6GTq3i0Am5fJc2meehN8B8JbI4DES2IXLcApnM/zpVpp13iaR+sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB4824.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(4744005)(5660300002)(316002)(86362001)(478600001)(83380400001)(6916009)(66476007)(8676002)(91956017)(2906002)(64756008)(53546011)(4326008)(66446008)(6506007)(76116006)(66946007)(66556008)(38070700005)(52536014)(8936002)(55016002)(9686003)(38100700002)(33656002)(7696005)(122000001)(186003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?qBM7AFHPzZ2ieY4seg+VtOkUNNPw7Y+bvelM56mXrI3JMvXB6rR9NmQ1pO?=
 =?iso-8859-1?Q?d9Bt0R7G/pkLWjQiqravIPWHmYRzsZWTFteYWl04OOAm7nL5jSYbfgZodT?=
 =?iso-8859-1?Q?dtrwv66WIkhxSu70wMAMsblDuw1VhvqO+3+WumLtzWrrVWxfHMYdtFd4pA?=
 =?iso-8859-1?Q?l52nea4CMxTMMwgwD4Quhs7g2SNj/fA2/Uh9jQMs+VzXwS15sgPvxAJLTV?=
 =?iso-8859-1?Q?v1BMAUL6jdH5YHJJI9QpzyoDcb8dd0KrCdHaMjDPI44FCU+kxdqh4z60JX?=
 =?iso-8859-1?Q?1IGc3cnOuLl2n5Pu/4vEZU1Tyc/oJPXRKXxkhePHs1lG6XL7RtcXzyWQNI?=
 =?iso-8859-1?Q?UQexfuuN3m7baHc0h7prZFPLCOYEuDZ5un9Vr2X/nG77EBiJ8bM2TZU7Q5?=
 =?iso-8859-1?Q?icihboZq3yt3hqQG5dZsn8fY1xCiR5zjwIlN1zKTbcZOlNDQORdQTSdWHi?=
 =?iso-8859-1?Q?dqf55OlmHORTwILK9amhd00duR53PqQ3PI7eUF8qtw6rkyO/49VzfG7M2h?=
 =?iso-8859-1?Q?TJVGqw9KoH7FnyjxefC2YB+rGKIIFiK0cEKP/Ejoabe8d5OZydSlWBJlho?=
 =?iso-8859-1?Q?WzEp9hmxGGH3k8gCoEqLhX6HHl/hxxyVzcANaYvOVSyCejtAo/POtQWhJh?=
 =?iso-8859-1?Q?woZ/KPFfgNpkz0ec9EAEpYnRvJJfgSt0wZW24qZqTT346QOLaHmVjTdtcq?=
 =?iso-8859-1?Q?2jtH/pzav947+C6IlMkLV7/IumOb9d7d0h3mHwE407VoDZmenb5BTEtqFh?=
 =?iso-8859-1?Q?1SLjcIJRyr1trxNCBx7VTldbXevkTPhreZszMzfZNMC8SifHbWbDXfwFAo?=
 =?iso-8859-1?Q?E5AU5zSTM9r7gXcd8YEMp7GyRbBWhAraVX6ta12NoouvM96d0s4xU7NW/i?=
 =?iso-8859-1?Q?lvb7lY4NDpvWzlwfZpy/tUBvhOaUiZfUMram2Cqi9No4n0LXIFWaJCOhRj?=
 =?iso-8859-1?Q?1kdVVWMKB3FhvldfhJpky0qsUp2bTppdHhDadm04Te+RxXiNQOPohdUaMy?=
 =?iso-8859-1?Q?lpsLeCD2s9OoU1PwJk1Hf0Y0SQnGlYOog4OLBJx+5o6aseVfJfrTjA/sip?=
 =?iso-8859-1?Q?xX/C/b4e7MR/fo2ICUOm+oOpFFozCFBcVbJsIZSTmyuYPWhfMRcVNWbkIa?=
 =?iso-8859-1?Q?xCctBzO9RFIfbjOCUqv27O0Zf+A2RQ77mxRoO4HJnbiFFpgwSmrZYxWzU+?=
 =?iso-8859-1?Q?oU7BnJvpD+8uam+b+vnRDhCbmhZYGmX3eD5B02NC1enCUB7U7rFs8zaGKg?=
 =?iso-8859-1?Q?C22rZYld7gMpErkan8TN863DFjrYNqFtJEjjg0oDz9Whjip3JQT1P2iuG6?=
 =?iso-8859-1?Q?vHJ05qzqPcOh7RjULBo0d5CxnWPVHi/3YUY2Yw+STFUwup0nHqklF+QNBf?=
 =?iso-8859-1?Q?E75hiU6nBn6dArvOz+djCmXrgqD3aNGg=3D=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB4824.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d64e34-b097-4d4f-02aa-08d97320eca9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 23:32:29.5446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8ICfffYoDw9Eixe/Gso9DH7duCzAOt/EXyA5xOXaAqJvb2+dlkdl9EMOB+Vjjit0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR15MB3856
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: hTHb8EV_TB8jouOWA1lN4UAb_WB6ECr3
X-Proofpoint-ORIG-GUID: hTHb8EV_TB8jouOWA1lN4UAb_WB6ECr3
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-08_10:2021-09-07,2021-09-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=584 impostorscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080146
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wednesday, September 8, 2021 3:44 PM, Eric Biggers wrote:=0A=
> Sorry, I didn't notice that you had already sent out a new version of thi=
s=0A=
> patch.  Is this version intended to address all my comments?  Some of the=
=0A=
> comments I made don't seem to have been fully addressed.=0A=
=0A=
Hi!=0A=
=0A=
Yes, the patch was intended to address all of your previous comment.=0A=
=0A=
I went over it to double check and noticed that I somehow left one OPENSSL_=
IS_BORINGSSL ifdef in programs/cmd_sign.c.=0A=
=0A=
I will remove it in V3. As far as I can tell, all of your other comments ar=
e already addressed, unless I'm still missing something?=
